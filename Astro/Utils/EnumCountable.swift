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

/**
 EnumCountable provides an easy way to add a static count constant to Swift enums of type Int.
 
 It requires that the first case start at 0 and all cases must be continuous.
 
 Usage:
 ```
 enum MyEnum: Int, EnumCountable {
    case case1 = 0
    case case2
    case case3
 
    static let count = MyEnum.countCases()  // Lazy-initialize the constant 'count' to the number of enum cases
 }
 ```
 */
public protocol EnumCountable {
    static var count: Int { get }
}

public extension EnumCountable where Self : RawRepresentable, Self.RawValue == Int {
    
    /**
    Counts the number of cases in the enum, starting at 0
    */
    static func countCases() -> Int {
        var count = 0
        while let _ = Self(rawValue: count) {
            count += 1
        }
        return count
    }
}
