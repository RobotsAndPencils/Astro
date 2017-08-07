//  Copyright © 2016 Robots and Pencils, Inc. All rights reserved.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

/**
 LayoutLabel implements some logic to ensure that a UILabel properly resizes itself based on its content.
 Used in situations like determining cell height in a UITableView, ensuring that labels fit their content
 after a constraint change, etc...
 
 Based on http://stackoverflow.com/questions/18118021/how-to-resize-superview-to-fit-all-subviews-with-autolayout
 */
open class LayoutLabel: UILabel {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if numberOfLines == 0 && preferredMaxLayoutWidth != frame.size.width {
            preferredMaxLayoutWidth = frame.size.width
            setNeedsUpdateConstraints()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        
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
