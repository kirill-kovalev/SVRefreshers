//
//  FooterRefresherView.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public class FooterRefresherView: BaseRefresherView {
    
    override func scrollViewDidScroll(to offset: CGPoint) {
        guard let scrollView = scrollView else { return }
        
        if scrollView.contentSize.height + scrollView.contentInset.top > scrollView.bounds.size.height {
            
            if scrollView.contentSize.height - scrollView.contentOffset.y + scrollView.contentInset.bottom  <= scrollView.bounds.size.height {
                begin()
            }
        } else {
            
            if scrollView.contentOffset.y + scrollView.contentInset.top >= animator.trigger / 2.0 {
                begin()
            }
        }
    }
    
    override func begin() {
        guard !isExecuting, !isHidden, let scrollView = scrollView else { return }
        super.begin()
        isExecuting = true
        
        setNeedsLayout()
        layoutIfNeeded()
        
        scrollView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.bottom += self.animator.execute
            scrollView.contentOffset.y -= self.animator.execute
            scrollView.layoutIfNeeded()
        }) { (finished) in
            DispatchQueue.main.async {
                self.handler?()
            }
        }
    }
    
    override func end() {
        guard isExecuting else { return }
        isExecuting = false
        
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
            scrollView.contentInset.bottom -= self.animator.execute
            scrollView.contentOffset.y += self.animator.execute
            scrollView.layoutIfNeeded()
        }) { (finished) in
            self.animator.refreshEnd(view: self, finish: true)
        }
    }
    
}
