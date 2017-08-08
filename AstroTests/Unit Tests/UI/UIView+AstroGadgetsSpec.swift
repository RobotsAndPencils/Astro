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

class UIViewAstroGadgetsSpec: QuickSpec {
    override func spec() {
        describe("Given a UIView with a defined frame") {
            let view = UIView()
            beforeEach {
                // Arrange
                view.frame = CGRect(x: 1, y: 2, width: 3, height: 4)
            }
            context("when updating a frame property") {
                it("then the frameSize should match") {
                    // Arrange
                    let expectedSize = CGSize(width: 23, height: 45)
                    // Act
                    view.frameSize = expectedSize
                    // Assert
                    expect(view.frameSize).to(equal(expectedSize))
                    expect(view.frame.size).to(equal(expectedSize))
                }
                it ("then the frameHeight should match") {
                    // Arrange
                    let expectedHeight: CGFloat = 12.0
                    // Act
                    view.frameHeight = expectedHeight
                    // Assert
                    expect(view.frameHeight).to(equal(expectedHeight))
                    expect(view.frame.size.height).to(equal(expectedHeight))
                }
                it ("then the frameWidth should match") {
                    // Arrange
                    let expectedWidth: CGFloat = 347.0
                    // Act
                    view.frameWidth = expectedWidth
                    // Assert
                    expect(view.frameWidth).to(equal(expectedWidth))
                    expect(view.frame.size.width).to(equal(expectedWidth))
                }
                it ("then the frameOrigin should match") {
                    // Arrange
                    let expectedOrigin = CGPoint(x: 67, y: 89)
                    // Act
                    view.frameOrigin = expectedOrigin
                    // Assert
                    expect(view.frameOrigin).to(equal(expectedOrigin))
                    expect(view.frame.origin).to(equal(expectedOrigin))
                }
                it ("then the frameX should match") {
                    // Arrange
                    let expectedX: CGFloat = 567.0
                    // Act
                    view.frameX = expectedX
                    // Assert
                    expect(view.frameX).to(equal(expectedX))
                    expect(view.frame.origin.x).to(equal(expectedX))
                }
                it ("then the frameY should match") {
                    // Arrange
                    let expectedY: CGFloat = 678.0
                    // Act
                    view.frameY = expectedY
                    // Assert
                    expect(view.frameY).to(equal(expectedY))
                    expect(view.frame.origin.y).to(equal(expectedY))
                }
            }
        }
    }
}
