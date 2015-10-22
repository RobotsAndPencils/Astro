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
        describe("Given a UIView with a defined frame") {
            let view = UIView()
            beforeEach(){
                // Arrange
                view.frame = CGRectMake(1, 2, 3, 4)
            }
            context("when updating a frame property") {
                it("then the frameSize should match") {
                    // Arrange
                    let expectedSize = CGSizeMake(23, 45)
                    // Act
                    view.frameSize = expectedSize
                    // Assert
                    expect(view.frameSize).to(equal(expectedSize))
                    expect(view.frame.size).to(equal(expectedSize))
                }
                it ("then the frameHeight should match") {
                    // Arrange
                    let expectedHeight:CGFloat = 12.0
                    // Act
                    view.frameHeight = expectedHeight
                    // Assert
                    expect(view.frameHeight).to(equal(expectedHeight))
                    expect(view.frame.size.height).to(equal(expectedHeight))
                }
                it ("then the frameWidth should match") {
                    // Arrange
                    let expectedWidth:CGFloat = 347.0
                    // Act
                    view.frameWidth = expectedWidth
                    // Assert
                    expect(view.frameWidth).to(equal(expectedWidth))
                    expect(view.frame.size.width).to(equal(expectedWidth))
                }
                it ("then the frameOrigin should match") {
                    // Arrange
                    let expectedOrigin = CGPointMake(67,89)
                    // Act
                    view.frameOrigin = expectedOrigin
                    // Assert
                    expect(view.frameOrigin).to(equal(expectedOrigin))
                    expect(view.frame.origin).to(equal(expectedOrigin))
                }
                it ("then the frameX should match") {
                    // Arrange
                    let expectedX:CGFloat = 567.0
                    // Act
                    view.frameX = expectedX
                    // Assert
                    expect(view.frameX).to(equal(expectedX))
                    expect(view.frame.origin.x).to(equal(expectedX))
                }
                it ("then the frameY should match") {
                    // Arrange
                    let expectedY:CGFloat = 678.0
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
