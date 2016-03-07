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
