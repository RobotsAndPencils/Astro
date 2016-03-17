//
//  EnumCountableSpec.swift
//  Astro
//
//  Created by Jen on 2016-02-12.
//  Copyright © 2016 Robots and Pencils. All rights reserved.
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
