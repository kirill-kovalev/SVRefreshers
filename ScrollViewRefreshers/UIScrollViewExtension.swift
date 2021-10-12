//
//  UIScrollViewExtension.swift
//  ScrollViewRefreshers
//
//  Created by Кирилл on 12.10.2021.
//

import UIKit

extension UIView {
    func systemLayoutSizeFittingWidth(_ width: CGFloat) -> CGSize {
        let fittingSize = CGSize(width: width, height: 0)
        let newSize = self.systemLayoutSizeFitting(fittingSize,
                                                   withHorizontalFittingPriority: .required,
                                                   verticalFittingPriority: .fittingSizeLevel)
        return newSize
    }
}


extension UIScrollView {
    
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateHeaderFooter()
    }
    
    func updateHeaderFooter() {
        let availableWidth = frame.inset(by: adjustedContentInset).size.width
        
        if let header = header {
            header.frame.size = header.systemLayoutSizeFittingWidth(availableWidth)
            header.frame.origin = .init(x: 0,
                                        y: -header.frame.size.height)
        }
        
        if let footer = footer {
            footer.frame.size = systemLayoutSizeFittingWidth(availableWidth)
            footer.frame.origin = .init(x: 0,
                                        y: contentSize.height)
        }
    }
}
