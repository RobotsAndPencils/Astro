//
//  LayoutLabelSpec.swift
//  Astro
//
//  Created by Andrew Erickson on 2016-03-02.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
//

import Quick
import Nimble
@testable import Astro

let mockFrame = CGRectMake(1, 2, 3, 4)

class LayoutLabelSpec: QuickSpec {
    override func spec() {
        describe("Given a LayoutLabel") {
            let label = LayoutLabel(frame: mockFrame)
            
            context("when layoutSubviews is called") {
                context("numberOfLines is set to 0") {
                    beforeEach {
                        //Arrange
                        label.numberOfLines = 0
                    }
                    
                    it("the the preferred max width should equal the frame width") {
                        //Act
                        label.layoutSubviews()
                        
                        //Assert
                        expect(label.preferredMaxLayoutWidth).to(equal(label.frame.size.width))
                    }
                }
            }
            
            context("when intrinsicContentSize is called") {
                let comparableLabel = UILabel(frame: mockFrame)
                
                context("numberOfLines is set to 0") {
                    beforeEach {
                        label.numberOfLines = 0
                        comparableLabel.numberOfLines = 0
                    }
                    
                    context("if text is empty") {
                        beforeEach {
                            label.text = ""
                            comparableLabel.text = ""
                        }
                        
                        it("contentSize should remain the same") {
                            //Act
                            let contentSize = label.intrinsicContentSize()
                            let comparableContentSize = comparableLabel.intrinsicContentSize()
                            
                            //Assert
                            expect(contentSize.height).to(equal(comparableContentSize.height))
                        }
                    }
                    
                    context("if text is not empty") {
                        beforeEach {
                            label.text = "a"
                            comparableLabel.text = "a"
                        }
                        
                        it("contentSize should be 1pt taller") {
                            //Act
                            let contentSize = label.intrinsicContentSize()
                            let comparableContentSize = comparableLabel.intrinsicContentSize()
                            
                            //Assert
                            expect(contentSize.height).to(equal(comparableContentSize.height+1))
                        }
                    }
                }
                
                context("numberOfLines is not 0") {
                    beforeEach {
                        label.numberOfLines = 1
                        comparableLabel.numberOfLines = 1
                    }
                    
                    it("content size should remain the same") {
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
