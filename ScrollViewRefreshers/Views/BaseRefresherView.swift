//
//  BaseRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class BaseRefresherView: UIView {
    
    let handler: RefreshHandler?
    var animator: RefreshAnimator
    
    var scrollView: UIScrollView? { superview as? UIScrollView }
    
    required init?(coder: NSCoder) { return nil }
    public init(animator: RefreshAnimator, handler: RefreshHandler? = nil) {
        self.handler = handler
        self.animator = animator
        super.init(frame: .zero)
        
        addSubview(animator.view)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        animator.view.frame = self.bounds
    }
    
    public override var intrinsicContentSize: CGSize {
        .init(width: .greatestFiniteMagnitude, height: animator.hold) // isHidden ? .zero :
    }
    
    public override var isHidden: Bool {
        didSet {
            invalidateIntrinsicContentSize()
            scrollView?.layoutIfNeeded() // layouting uiscrollView to update Header and footer sizes
        }
    }
    
    private var observation: NSKeyValueObservation!
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        observation = scrollView?.observe(\.contentOffset,
                                          options: [.initial, .old, .new],
                                          changeHandler: { [weak self] view, changes in
                                            if let newValue = changes.newValue {
                                                self?.scrollViewDidScroll(to: newValue)
                                            }
                                          })
        layoutIfNeeded()
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        layoutIfNeeded()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        observation = nil
    }
    
    
    func begin() {
        animator.refreshBegin(view: self)
    }
    
    func end() {
        animator.refreshWillEnd(view: self)
    }
    
    func scrollViewDidScroll(to offset: CGPoint) { }
}
