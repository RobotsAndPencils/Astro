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
 Extends UICollectionView to simplify cell registration and dequeueing
 */
public extension UICollectionView {
    /**
     Registration method for subclasses implementing only ReusableView
     
     - parameter type: The cell subclass type that conforms to the ReusableView
     protocol
     */
    func registerCell<Cell: UICollectionViewCell>(ofType type: Cell.Type) {
        register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    /**
     Registration method for subclasses implementing both ReusableView and
     NibLoadableView
     
     - parameter type: The cell subclass type that conforms to both ReusableView
     and NibLoadableView protocols
     */
    func registerCell<Cell: UICollectionViewCell>(ofType type: Cell.Type) where Cell: NibLoadableView {
        register(type.nib, forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    /**
     Registers a UICollectionReusableView subclass for use in creating supplementary views for the collection view.

     - parameter kind: The kind of supplementary view to retrieve
     - parameter type: The UICollectionReusableView subclass type to register
     */
    func registerReusableSupplementaryView<View: UICollectionReusableView>(ofKind kind: String, type: View.Type) {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.identifier)
    }
    
    /**
     Ideal cell dequeueing method for cell subclasses which conform to 
     ReusableView – a nice detail is that it accepts a type, rather than reuse
     identifier
     
     - parameter type: The cell subclass type that conforms to the ReusableView
     protocol
     - parameter indexPath: The index path of the cell to dequeue
     */
    func dequeueReusableCell<Cell: UICollectionViewCell>(ofType type: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue collection view cell with identifier: \(type.reuseIdentifier)")
        }
        return cell
    }

    /**
     Ideal dequeueing method for reusable supplementary views which conform to
     ReusableView – a nice detail is that it accepts a type, rather than reuse
     identifier

     - parameter kind: The kind of supplementary view to retrieve
     - parameter type: The UICollectionReusableView subclass type to retrieve
     - parameter indexPath: The index path specifying the location of the supplementary view in the collection view
     */
    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(ofKind kind: String, type: View.Type, for indexPath: IndexPath) -> View {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.identifier, for: indexPath) as? View else {
            fatalError("Could not dequeue supplementary view with identifier: \(type.identifier)")
        }
        return view
    }
}
