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

import Foundation

/**
 Encapsulates a change between two values of the same type

 Sometimes you need the old and new values of a property in order to perform
 efficient or pleasing changes elsewhere, like in your UI. This type makes that
 simpler by allowing you to pass a single value around. It's then possible to
 get sub-changes with the `change[at: \.value]` subscript.

 ## Example

 ```
 var model: ViewModel {
   didSet {
     let change = Change(old: oldValue, new: model)
     updateUI(with: change)
   }
 }

 func updateUI(with change: Change<Model>) {
   title = change.new.title
   updateSomeSubview(with: change[at: \.subviewState])
   // ...
 }

 func updateSomeSubview(with change: Change<SubviewState>) {
   guard change.isDifferent else { return }
   // ...
 }
 ```
 */
public struct Change<Value> {
    public let old: Value
    public let new: Value

    public init(old: Value, new: Value) {
        self.old = old
        self.new = new
    }

    /**
     Create a Change between old and new child values at a particular key path
     */
    public subscript<ChildValue>(at keyPath: KeyPath<Value, ChildValue>) -> Change<ChildValue> {
        return Change<ChildValue>(old: old[keyPath: keyPath], new: new[keyPath: keyPath])
    }
}

extension Change where Value: Equatable {
    public var isDifferent: Bool {
        return old != new
    }
}

