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

import Foundation

public extension Sequence {
    /**
     Returns a Boolean value indicating whether the value at the given key path for all elements is true.
     */
    func allSatisfy(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        return allSatisfy(get(keyPath))
    }

    /**
     Returns an array containing the non-nil values at the given key path for each element of this sequence.

     Use this method to receive an array of nonoptional values when the key path's value is optional.
     */
    func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return compactMap(get(keyPath))
    }

    /**
     Returns a Boolean value indicating whether the sequence contains an element where the key path's value is true.
     */
    func contains(where keyPath: KeyPath<Element, Bool>) -> Bool {
        return contains(where: get(keyPath))
    }

    /**
     Returns a subsequence by skipping the initial, consecutive elements whose value at the given key path is true.
     */
    func drop(while keyPath: KeyPath<Element, Bool>) -> DropWhileSequence<Self> {
        return drop(while: get(keyPath))
    }

    /**
     Returns an array containing, in order, the elements of the sequence with true values at the given key path.
     */
    func filter(_ keyPath: KeyPath<Element, Bool>) -> [Element] {
        return filter(get(keyPath))
    }

    /**
     Returns the first element of the sequence whose value at the given key path is true.
     */
    func first(where keyPath: KeyPath<Element, Bool>) -> Element? {
        return first(where: get(keyPath))
    }

    /**
     Returns an array containing the concatenated values at the given key path for each element of this sequence.

     Use this method to receive a single-level collection when the key path's value type is a sequence or collection for each element.
     */
    func flatMap<S>(_ keyPath: KeyPath<Element, S>) -> [S.Element] where S: Sequence {
        return flatMap(get(keyPath))
    }

    /**
     Returns an array containing the values at the given key path for each element.
     */
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map(get(keyPath))
    }

    /**
     Returns a subsequence containing the initial, consecutive elements with true values at the given key path.
     */
    func prefix(while keyPath: KeyPath<Element, Bool>) -> [Element] {
        return prefix(while: get(keyPath))
    }

    /**
     Returns the elements of the sequence, sorted using the < operator on the values at the given key path.
     */
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted(by: { first, second in
            return first[keyPath: keyPath] < second[keyPath: keyPath]
        })
    }
}

/**
 Converts a KeyPath into the equivalent function
 */
func get<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in root[keyPath: keyPath] }
}
