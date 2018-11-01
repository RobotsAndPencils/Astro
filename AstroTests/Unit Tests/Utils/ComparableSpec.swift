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

class ComparableSpec: QuickSpec {
    override func spec() {
        describe("clamp") {
            context("x is less than min") {
                it("returns min") {
                    var result = 0
                    result.clamp(to: 5...10)
                    expect(result).to(equal(5))
                }
            }
            context("x is equal to min") {
                it("returns min") {
                    var result = 5
                    result.clamp(to: 5...10)
                    expect(result).to(equal(5))
                }
            }
            context("x is between min and max") {
                it("returns x") {
                    var result = 5
                    result.clamp(to: 0...10)
                    expect(result).to(equal(5))
                }
            }
            context("x is equal to max") {
                it("returns max") {
                    var result = 10
                    result.clamp(to: 5...10)
                    expect(result).to(equal(10))
                }
            }
            context("x is greater than max") {
                it("returns max") {
                    var result = 10
                    result.clamp(to: 0...5)
                    expect(result).to(equal(5))
                }
            }
        }

        describe("clamped") {
            context("x is less than min") {
                it("returns min") {
                    let result = 0.clamped(to: 5...10)
                    expect(result).to(equal(5))
                }
            }
            context("x is equal to min") {
                it("returns min") {
                    let result = 5.clamped(to: 5...10)
                    expect(result).to(equal(5))
                }
            }
            context("x is between min and max") {
                it("returns x") {
                    let result = 5.clamped(to: 0...10)
                    expect(result).to(equal(5))
                }
            }
            context("x is equal to max") {
                it("returns max") {
                    let result = 10.clamped(to: 5...10)
                    expect(result).to(equal(10))
                }
            }
            context("x is greater than max") {
                it("returns max") {
                    let result = 10.clamped(to: 0...5)
                    expect(result).to(equal(5))
                }
            }
        }
    }
}

