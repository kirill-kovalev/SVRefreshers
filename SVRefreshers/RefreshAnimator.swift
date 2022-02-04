//
//  RefreshAnimator.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public protocol RefreshAnimator {
    
    /// Refresher view
    var view: UIView { get }
    
    /// Height at which refresh is triggered
    var trigger: CGFloat { get }
    
    /// Height while loading
    var execute: CGFloat { get }
    /// Height while not triggered
    var hold: CGFloat { get }
    
    /// The delay time at the end of the animation, in seconds
    var endDelay: CGFloat { get }
    
    /// refresher view triggered
    mutating func refreshBegin(view: BaseRefresherView)
    
    /// refresher view is about to hide
    mutating func refreshWillEnd(view: BaseRefresherView)
    
    /// refresher view will be triggered if scroll view released
    mutating func refreshWillTrigger(view: BaseRefresherView, will trigger: Bool)

    /// refresher view is hidden
    mutating func refreshEnd(view: BaseRefresherView, finish: Bool)

    /// refresher progress changed
    mutating func refresh(view: BaseRefresherView, progressDidChange progress: CGFloat)
}

