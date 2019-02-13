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

class UIViewControllerAstroGadgetsSpec: QuickSpec {
    override func spec() {
        describe("addChildViewController() - Given a view controller") {
            var parentViewController: UIViewController!
            var childViewController: UIViewController!
            
            context("when adding a child view controller") {
                beforeEach {
                    // Arrange
                    parentViewController = UIViewController()
                    parentViewController.view = UIView()
                    childViewController = UIViewController()
                    childViewController.view = UIView()
                    // Act
                    parentViewController.addChild(childViewController, inContainer: parentViewController.view)
                }
                
                it("then the child view controller should have been added") {
                    // Assert
                    expect(parentViewController.children[0]).to(equal(childViewController))
                }
                it("then the child view controller view should be added to the given view") {
                    // Assert
                    expect(parentViewController.view.subviews[0]).to(equal(childViewController.view))
                }
            }
        }
    }
}
