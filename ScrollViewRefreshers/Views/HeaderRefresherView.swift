//
//  HeaderRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class HeaderRefresherView: BaseRefresherView {
    
    private var isUpdating = false
    
    override func scrollViewDidScroll(to offset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
//        scrollView.layoutIfNeeded()
        
        let offsets = scrollView.adjustedContentInset.top + offset.y
        
        if offsets < -animator.trigger, !isUpdating, !scrollView.isDragging {
            begin()
        }
        
        if !isUpdating {
            let percent = -offsets / animator.trigger
            animator.refresh(view: self, progressDidChange: percent)
        }
    }
    
    
    override func begin() {
        guard !isUpdating, !isHidden, let scrollView = scrollView else { return }
        super.begin()
        isUpdating = true
        
        setNeedsLayout()
        layoutIfNeeded()
        
        scrollView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.top += self.animator.execute
            scrollView.layoutIfNeeded()
        }) { (finished) in
            DispatchQueue.main.async {
                self.handler?()
            }
        }
    }
    
    override func end() {
        guard isUpdating else { return }
        isUpdating = false
        
        let delay = Int(self.animator.endDelay * 100)
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
        scrollView.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.top -= self.animator.execute
            scrollView.layoutIfNeeded()
        }) { (finished) in
            self.animator.refreshEnd(view: self, finish: true)
        }
    }
}
