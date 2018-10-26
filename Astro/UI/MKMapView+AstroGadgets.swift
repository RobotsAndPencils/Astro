//  Copyright © 2018 Robots and Pencils, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import MapKit

extension MKMapView {
    /**
     Registers annotation view based on its reuse identifier

    - parameter type:  The annotation view type
    */
    @available(iOS 11.0, *)
    public func registerView<View: MKAnnotationView>(ofType type: View.Type) {
        register(type.self, forAnnotationViewWithReuseIdentifier: type.reuseIdentifier)
    }

    /**
     Dequeue an annotation view that is registered with its own reuse identifier

     - parameter type:  The annotation view type
     */
    func dequeueReusableAnnotationView<View: MKAnnotationView>(ofType type: View.Type) -> View {
        guard let view = dequeueReusableAnnotationView(withIdentifier: type.reuseIdentifier) as? View else {
            fatalError("Could not dequeue table view cell with identifier: \(type.reuseIdentifier)")
        }
        return view
    }

    /**
     Dequeue an annotation view that is registered with its own reuse
     identifier, for a particular type of annotation

     - parameter type:  The annotation view type
     - parameter type:  The annotation type, which conforms to IdentifiableType
     */
    @available(iOS 11.0, *)
    func dequeueReusableAnnotationView<View: MKAnnotationView, Annotation: MKAnnotation & IdentifiableType>(ofType type: View.Type, for annotation: Annotation) -> View {
        guard let view = dequeueReusableAnnotationView(withIdentifier: type.reuseIdentifier, for: annotation) as? View else {
            fatalError("Could not dequeue annotation view with identifier: \(type.reuseIdentifier)")
        }
        return view
    }
}
