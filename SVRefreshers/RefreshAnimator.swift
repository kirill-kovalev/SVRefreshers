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
    
//    /// 开始刷新
    mutating func refreshBegin(view: BaseRefresherView)
//
//    /// 将要开始刷新
    mutating func refreshWillEnd(view: BaseRefresherView)
//
//    /// 结束刷新
    mutating func refreshEnd(view: BaseRefresherView, finish: Bool)
//
//    /// 刷新进度的变化
    mutating func refresh(view: BaseRefresherView, progressDidChange progress: CGFloat)
}

