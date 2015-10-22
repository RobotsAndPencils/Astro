//
//  UIViewController+AstroGadgetsSpec.swift
//  Astro
//
//  Created by Dominic Pepin on 2015-10-21.
//  Copyright © 2015 Robots and Pencils. All rights reserved.
//

import Quick
import Nimble
@testable import Astro

class UIViewController_AstroGadgetsSpec: QuickSpec {
    override func spec() {
        describe("addChildViewController() - Given a view controller") {
            var parentViewController:UIViewController!
            var childViewController:UIViewController!
            
            context("when adding a child view controller") {
                beforeEach(){
                    // Arrange
                    parentViewController = UIViewController()
                    parentViewController.view = UIView()
                    childViewController = UIViewController()
                    childViewController.view = UIView()
                    // Act
                    parentViewController.addChildViewController(childViewController, inContainer: parentViewController.view)
                }
                
                it("then the child view controller should have been added") {
                    // Assert
                    expect(parentViewController.childViewControllers[0]).to(equal(childViewController))
                }
                it("then the child view controller view should be added to the given view") {
                    // Assert
                    expect(parentViewController.view.subviews[0]).to(equal(childViewController.view))
                }
            }
        }
    }
}
