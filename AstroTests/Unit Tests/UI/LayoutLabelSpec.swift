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

let mockFrame = CGRectMake(1, 2, 3, 4)

class LayoutLabelSpec: QuickSpec {
    override func spec() {
        describe("Given a LayoutLabel") {
            let label = LayoutLabel(frame: mockFrame)
            
            context("when layoutSubviews is called and numberOfLines is set to 0 ") {
                beforeEach {
                    //Arrange
                    label.numberOfLines = 0
                    
                    //Act
                    label.layoutSubviews()
                }
                
                it("then the preferred max width should equal the frame width") {
                    //Assert
                    expect(label.preferredMaxLayoutWidth).to(equal(label.frame.size.width))
                }
            }
            
            context("when intrinsicContentSize is called") {
                
                let comparableLabel = UILabel(frame: mockFrame)
                
                context("and numberOfLines is set to 0") {
                    beforeEach {
                        //Arrange
                        label.numberOfLines = 0
                        comparableLabel.numberOfLines = 0
                    }
                    
                    context("and text is empty") {
                        beforeEach {
                            //Arrange
                            label.text = ""
                            comparableLabel.text = ""
                        }
                        
                        it("then contentSize should remain the same") {
                            //Act
                            let contentSize = label.intrinsicContentSize()
                            let comparableContentSize = comparableLabel.intrinsicContentSize()
                            
                            //Assert
                            expect(contentSize.height).to(equal(comparableContentSize.height))
                        }
                    }
                    
                    context("and text is not empty") {
                        beforeEach {
                            //Arrange
                            label.text = "a"
                            comparableLabel.text = "a"
                        }
                        
                        it("then contentSize should be 1pt taller") {
                            //Act
                            let contentSize = label.intrinsicContentSize()
                            let comparableContentSize = comparableLabel.intrinsicContentSize()
                            
                            //Assert
                            expect(contentSize.height).to(equal(comparableContentSize.height+1))
                        }
                    }
                }
                
                context("and numberOfLines is not 0") {
                    beforeEach {
                        //Arrange
                        label.numberOfLines = 1
                        comparableLabel.numberOfLines = 1
                    }
                    
                    it("then content size should remain the same") {
                        //Act
                        let contentSize = label.intrinsicContentSize()
                        let comparableContentSize = comparableLabel.intrinsicContentSize()
                        
                        //Assert
                        expect(contentSize.height).to(equal(comparableContentSize.height))
                    }
                }
            }
        }
    }
}
