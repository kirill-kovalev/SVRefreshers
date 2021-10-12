//
//  ScrollRefresherDSL.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

public typealias RefreshHandler = (() -> Void)

public extension UIScrollView {
    var cr: ScrollRefresherDSL { .init(view: self) }
}

extension UIScrollView {
    var footer: FooterRefresherView? {
        subviews.compactMap({ $0 as? FooterRefresherView }).first
    }
    
    var header: HeaderRefresherView? {
        subviews.compactMap({ $0 as? HeaderRefresherView }).first
    }
}

public struct ScrollRefresherDSL {

    let view: UIScrollView
    
    public var footer: FooterRefresherView? {
        view.subviews.compactMap({ $0 as? FooterRefresherView }).first
    }
    public var header: HeaderRefresherView? {
        view.subviews.compactMap({ $0 as? HeaderRefresherView }).first
    }
    
    public func endHeaderRefresh() {
        view.header?.end()
    }
    
    public func endLoadingMore() {
        view.footer?.end()
    }
    
    public func addHeadRefresh(
        animator: RefreshAnimator,
        insets: UIEdgeInsets = .zero,
        handeler: RefreshHandler? = nil
    ) {
        let newHeader = HeaderRefresherView(animator: animator, handler: handeler)
        newHeader.insets = insets
        header?.removeFromSuperview()
        view.addSubview(newHeader)
        DispatchQueue.main.async(execute: view.layoutIfNeeded)
    }
    
    public func addFootRefresh(
        animator: RefreshAnimator,
        insets: UIEdgeInsets = .zero,
        handeler: RefreshHandler? = nil
    ) {
        let newFooter = FooterRefresherView(animator: animator, handler: handeler)
        newFooter.insets = insets
        footer?.removeFromSuperview()
        view.addSubview(newFooter)
        DispatchQueue.main.async(execute: view.layoutIfNeeded)
    }
    
    public func removeFooter() {
        footer?.end()
        footer?.removeFromSuperview()
    }
    
    public func removeHeader() {
        header?.end()
        header?.removeFromSuperview()
    }
}
