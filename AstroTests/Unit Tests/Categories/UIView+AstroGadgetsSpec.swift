//
//  UIView+AstroGadgetsSpec.swift
//  Astro
//
//  Created by Dominic Pepin on 2015-10-21.
//  Copyright © 2015 Robots and Pencils. All rights reserved.
//

import Quick
import Nimble
@testable import Astro

class UIView_AstroGadgetsSpec: QuickSpec {
    override func spec() {
        describe("When setting setting a frame property") {
            let view = UIView()
            beforeEach(){
                // Arrange
                view.frame = CGRectMake(1, 2, 3, 4)
            }
            context("the set property should be returned in the getter") {
                it("frameSize()") {
                    // Arrange
                    let expectedSize = CGSizeMake(23, 45)
                    // Act
                    view.frameSize = expectedSize
                    // Assert
                    expect(view.frameSize).to(equal(expectedSize))
                    expect(view.frameSize).to(equal(view.frame.size))
                }
                it ("frameHeight()") {
                    // Arrange
                    let expectedHeight:CGFloat = 12.0
                    // Act
                    view.frameHeight = expectedHeight
                    // Assert
                    expect(view.frameHeight).to(equal(expectedHeight))
                    expect(view.frameHeight).to(equal(view.frame.size.height))
                }
                it ("frameWidth()") {
                    // Arrange
                    let expectedWidth:CGFloat = 347.0
                    // Act
                    view.frameWidth = expectedWidth
                    // Assert
                    expect(view.frameWidth).to(equal(expectedWidth))
                    expect(view.frameWidth).to(equal(view.frame.size.width))
                }
                it ("frameOrigin()") {
                    // Arrange
                    let expectedOrigin = CGPointMake(67,89)
                    // Act
                    view.frameOrigin = expectedOrigin
                    // Assert
                    expect(view.frameOrigin).to(equal(expectedOrigin))
                    expect(view.frameOrigin).to(equal(view.frame.origin))
                }
                it ("frameX()") {
                    // Arrange
                    let expectedX:CGFloat = 567.0
                    // Act
                    view.frameX = expectedX
                    // Assert
                    expect(view.frameX).to(equal(expectedX))
                    expect(view.frameX).to(equal(view.frame.origin.x))
                }
                it ("frameY()") {
                    // Arrange
                    let expectedY:CGFloat = 678.0
                    // Act
                    view.frameY = expectedY
                    // Assert
                    expect(view.frameY).to(equal(expectedY))
                    expect(view.frameY).to(equal(view.frame.origin.y))
                }
            }
        }
    }
}
