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
 Extends UITableView to simplify cell registration and dequeueing
 */
public extension UITableView {
    /**
     Registration method for subclasses implementing only ReusableView
     
     - parameter type: The cell subclass type that conforms to the ReusableView
     protocol
     */
    func registerCell<Cell: UITableViewCell>(ofType type: Cell.Type) {
        register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    /**
     Registration method for subclasses implementing both ReusableView and
     NibLoadableView
     
     - parameter type: The cell subclass type that conforms to both ReusableView
     and NibLoadableView protocols
     */
    func registerCell<Cell: UITableViewCell>(ofType type: Cell.Type) where Cell: NibLoadableView {
        register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
    }

    /**
     Registration method for subclasses implementing only ReusableView

     - parameter type: The cell subclass type that conforms to the ReusableView
     protocol
     */
    func registerHeaderFooterView<View: UITableViewHeaderFooterView>(ofType type: View.Type) {
        register(type.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }

    /**
     Registration method for subclasses implementing both ReusableView and
     NibLoadableView

     - parameter type: The cell subclass type that conforms to both ReusableView
     and NibLoadableView protocols
     */
    func registerHeaderFooterView<View: UITableViewHeaderFooterView>(ofType type: View.Type) where View: NibLoadableView {
        register(type.nib, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    /**
     Ideal cell dequeueing method for cell subclasses which conform to
     ReusableView – a nice detail is that it accepts a type, rather than reuse
     identifier

     - parameter type:  The cell subclass type that conforms to the ReusableView
     protocol
     - parameter indexPath: The index path of the cell to dequeue
     */
    func dequeueReusableCell<Cell: UITableViewCell>(ofType type: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue table view cell with identifier: \(type.reuseIdentifier)")
        }
        return cell
    }

    /**
     Ideal dequeueing method for reusable header/footer views which conform to
     ReusableView – a nice detail is that it accepts a type, rather than reuse
     identifier

     - parameter type:  The cell subclass type that conforms to the ReusableView
     protocol
     */
    func dequeueReusableHeaderFooterView<View: UITableViewHeaderFooterView>(ofType type: View.Type) -> View {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? View else {
            fatalError("Could not dequeue table header/footer view with identifier: \(type.reuseIdentifier)")
        }
        return view
    }
}
