//
//  HeaderRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class HeaderRefresherView: BaseRefresherView {
    
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
                                                        let newValue = changes.newValue?.top,
                                                        let oldValue = changes.oldValue?.top,
                                                        newValue != oldValue,
                                                        self.isExecuting == true
                                                    else { return }
                                                    
                                                    isFixing = true
                                                    
                                                    let height = self.animator.execute + self.insets.top + self.insets.bottom
                                                    
                                                    self.scrollView?.contentInset.top = newValue + height
                                                    
                                                    isFixing = false
                                                })
    }

    
    override func scrollViewDidScroll(to offset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
        let offsets = scrollView.adjustedContentInset.top + offset.y
        
        willTrigger = offsets < -animator.trigger - 5 && scrollView.isDragging
        
        if offsets < -animator.trigger, !isExecuting, !scrollView.isDragging {
            begin()
        }
        
        if !isExecuting {
            let percent = -offsets / animator.trigger
            animator.refresh(view: self, progressDidChange: percent)
        }
    }
    
    
    override func begin() {
        guard !isExecuting, !isHidden, let scrollView = scrollView else { return }
        super.begin()
        
        let height = animator.execute + insets.top + insets.bottom
        
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.top += height
            scrollView.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.async {
                self.handler?()
            }
        }
    }
    
    override func beginEnd() {
        guard isExecuting else { return }
        
        // using delay to set minimum execution time
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
        scrollView.contentInset.top -= height
        scrollView.layoutIfNeeded()
        
        isExecuting = false
    }
}
