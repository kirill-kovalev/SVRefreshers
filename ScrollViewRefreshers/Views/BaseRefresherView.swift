//
//  BaseRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class BaseRefresherView: UIView {
    
    var isExecuting = false
    
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
    
    public var insets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            scrollView?.layoutIfNeeded() // layouting uiscrollView to update Header and footer sizes
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            invalidateIntrinsicContentSize()
            scrollView?.layoutIfNeeded() // layouting uiscrollView to update Header and footer sizes
        }
    }
    

    public override func layoutSubviews() {
        super.layoutSubviews()
        animator.view.frame = self.bounds.inset(by: insets)
    }
    
    public override var intrinsicContentSize: CGSize {
        if isHidden { return .zero }
        
        let preferredHeight = isExecuting ? animator.execute : animator.hold
        
        let height = preferredHeight + insets.top + insets.bottom
        
        return .init(width: .greatestFiniteMagnitude, height: height)
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
        guard !isExecuting, !isHidden, let scrollView = scrollView else { return }
        animator.refreshBegin(view: self)
        isExecuting = true
        
        scrollView.layoutIfNeeded()
    }
    
    func end() {
        guard isExecuting, let scrollView = scrollView else { return }
        animator.refreshWillEnd(view: self)
        isExecuting = false
        
        scrollView.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(to offset: CGPoint) { }
}
