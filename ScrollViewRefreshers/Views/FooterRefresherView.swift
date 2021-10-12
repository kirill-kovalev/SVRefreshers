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
        
        scrollView.layoutIfNeeded()
        
        if scrollView.contentSize.height + scrollView.adjustedContentInset.top > scrollView.bounds.size.height {
            if scrollView.contentSize.height - scrollView.contentOffset.y + scrollView.adjustedContentInset.bottom <= scrollView.bounds.size.height {
                begin()
            }
        } else if scrollView.contentOffset.y + scrollView.adjustedContentInset.top >= animator.trigger / 2.0 {
            begin()
        }
    }
    
    override func begin() {
        guard !isExecuting, !isHidden, let scrollView = scrollView else { return }
        super.begin()
        
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
    
    override func end() {
        guard isExecuting else { return }
        
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
        
        let height = animator.execute + insets.top + insets.bottom
        
        super.end()
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.bottom -= height
            scrollView.contentOffset.y += height
            scrollView.layoutIfNeeded()
        }) { (finished) in
            self.animator.refreshEnd(view: self, finish: true)
        }
    }
    
}
