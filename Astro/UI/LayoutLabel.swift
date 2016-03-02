//
//  LayoutLabel.swift
//  Astro
//
//  Implementation ported from RoboKit
//  
//  LayoutLabel implements some logic to ensure that a UILabel properly resizes itself based on its content.
//  Used in situations like determining cell height in a UITableView, ensuring that labels fit their content
//  after a constraint change, etc...
//  Based on http://stackoverflow.com/questions/18118021/how-to-resize-superview-to-fit-all-subviews-with-autolayout

import UIKit

class LayoutLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if numberOfLines == 0 && preferredMaxLayoutWidth != frame.size.width {
            preferredMaxLayoutWidth = frame.size.width
            setNeedsUpdateConstraints()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        var contentSize = super.intrinsicContentSize()
        
        guard let text = text else {
            return contentSize
        }
        
        if numberOfLines == 0 && text.characters.count > 0 {
            // found out that sometimes intrinsicContentSize is 1pt too short!
            contentSize.height += 1
        }
        
        return contentSize
    }
}
