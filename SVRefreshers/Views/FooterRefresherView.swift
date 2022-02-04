//
//  FooterRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class FooterRefresherView: BaseRefresherView {
    
    private var insetsObservation: NSKeyValueObservation!
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        var isFixing = false
        insetsObservation = scrollView?.observe(\.contentInset,
                                                options: [.new],
                                                changeHandler: { [weak self] view, changes in
                                                    guard
                                                        let self = self,
                                                        !isFixing,
                                                        let newValue = changes.newValue?.bottom,
                                                        let oldValue = changes.oldValue?.bottom,
                                                        newValue != oldValue,
                                                        self.isExecuting == true
                                                    else { return }
                                                    
                                                    isFixing = true
                                                    
                                                    let height = self.animator.execute + self.insets.top + self.insets.bottom
                                                    
                                                    self.scrollView?.contentInset.bottom = newValue + height
                                                    
                                                    isFixing = false
                                                })
    }

    
    override func scrollViewDidScroll(to offset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
        scrollView.layoutIfNeeded()
        
        if scrollView.contentSize.height + scrollView.adjustedContentInset.top > scrollView.frame.size.height {
            if scrollView.contentSize.height - scrollView.contentOffset.y + scrollView.adjustedContentInset.bottom <= scrollView.frame.size.height {
                willTrigger = true
                begin()
            } else {
                willTrigger = false
            }
        } else if scrollView.contentOffset.y + scrollView.adjustedContentInset.top > animator.trigger {
            willTrigger = true
            begin()
        } else {
            willTrigger = false
        }
    }
    
    var contentSizeAtUpdateBegin: CGSize?
    
    override func begin() {
        guard !isExecuting, !isHidden, let scrollView = scrollView else { return }
        super.begin()
        
        contentSizeAtUpdateBegin = scrollView.contentSize
        
        let height = animator.execute + insets.top + insets.bottom
        
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.bottom += height
            scrollView.contentOffset.y -= height
            scrollView.layoutIfNeeded()
        }) { (finished) in
            DispatchQueue.main.async {
                self.handler?()
            }
        }
    }
    
    override func beginEnd() {
        guard isExecuting else { return }
        
        let delay = Int(self.animator.endDelay * 1000)
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: {
                self.endAnimated()
            })
        } else {
            endAnimated()
        }
    }
    
    private func endAnimated() {
        guard let scrollView = scrollView, isExecuting else { return }
        
        animator.refreshWillEnd(view: self)
        scrollView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.end()
        }) { finished in
            self.animator.refreshEnd(view: self, finish: finished)
        }
    }
    
    override func end() {
        guard let scrollView = scrollView, isExecuting else { return }
        
        
        let height = animator.execute + insets.top + insets.bottom
        
        scrollView.contentInset.bottom -= height

        // scrolling up only if new content size is smaller than the old one
        if let sz = self.contentSizeAtUpdateBegin, sz.height > scrollView.contentSize.height {
            scrollView.contentOffset.y += height
        }
        
        scrollView.layoutIfNeeded()
        
        isExecuting = false
    }
    
}
