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

import Quick
import Nimble
@testable import Astro

class EnumCountableSpec: QuickSpec {

    private enum Enum2: Int, EnumCountable {
        case case1 = 0
        case case2
        
        static let count = Enum2.countCases()
    }
    
    private enum Enum6: Int, EnumCountable {
        case case1 = 0
        case case2
        case case3
        case case4
        case case5
        case case6
        
        static let count = Enum6.countCases()
    }
    
    private enum EnumBad: Int, EnumCountable {
        case case1 = 5
        case case2
        
        static let count = EnumBad.countCases()
    }
    
    override func spec() {
        describe("Given you have an enum") {
            context("with 2 cases") {
                it("the count should be 2") {
                    expect(Enum2.count).to(equal(2))
                }
            }
            context("with 6 cases") {
                it("the count should be 6") {
                    expect(Enum6.count).to(equal(6))
                }
            }
            context("with 2 cases, but the first case does not start at 0") {
                it("the count should be 0") {
                    expect(EnumBad.count).to(equal(0))
                }
            }
        }
    }
}
