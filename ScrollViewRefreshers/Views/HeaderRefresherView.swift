//
//  HeaderRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class HeaderRefresherView: BaseRefresherView {

    
    override func scrollViewDidScroll(to offset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
        let offsets = scrollView.adjustedContentInset.top + offset.y
        
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
    
    override func end() {
        guard isExecuting else { return }
        
        let delay = Int(self.animator.endDelay * 1000)
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: {
                self.animatedFinish()
            })
        } else {
            animatedFinish()
        }
    }
    
    private func animatedFinish() {
        guard let scrollView = scrollView else { return }
        super.end()
        
        let height = animator.execute + insets.top + insets.bottom

        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.top -= height
            scrollView.layoutIfNeeded()
        }) { (finished) in
            self.animator.refreshEnd(view: self, finish: true)

        }
    }
}
