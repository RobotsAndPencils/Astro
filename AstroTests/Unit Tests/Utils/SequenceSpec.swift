//  Copyright © 2018 Robots and Pencils, Inc. All rights reserved.
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

class SequenceSpec: QuickSpec {
    override func spec() {
        describe("allSatisfy") {
            it("returns true when all elements' values are true") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: "One", isActive: true)
                ].allSatisfy(\.isActive))
                .to(beTrue())
            }

            it("returns false when not all elements' values are true") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: "One", isActive: false)
                ].allSatisfy(\.isActive))
                .to(beFalse())
            }
        }

        describe("compactMap") {
            it("returns all non-nil values") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: nil, isActive: true)
                ].compactMap(\.name))
                .to(equal(["Zero"]))
            }
        }

        describe("contains") {
            it("returns true if one element's value is true") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: nil, isActive: false)
                ].contains(where: \.isActive))
                .to(beTrue())
            }
        }

        describe("drop(while:)") {
            it("returns subsequence skipping initial true values") {
                expect(Array([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: nil, isActive: false)
                ].drop(while: \.isActive)))
                .to(equal([TestElement(id: 1, name: nil, isActive: false)]))
            }
        }

        describe("filter") {
            it("returns elements with true values") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: nil, isActive: false)
                ].filter(\.isActive))
                .to(equal([TestElement(id: 0, name: "Zero", isActive: true)]))
            }
        }

        describe("first(where:)") {
            it("returns first element with true value") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: false),
                    TestElement(id: 1, name: "One", isActive: true)
                ].first(where: \.isActive))
                .to(equal(TestElement(id: 1, name: "One", isActive: true)))
            }
        }

        describe("flatMap") {
            it("returns concatenated values at key path") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: false, tags: ["Tag1", "Tag2"]),
                    TestElement(id: 1, name: "One", isActive: true, tags: ["Tag3"])
                ].flatMap(\.tags))
                .to(equal(["Tag1", "Tag2", "Tag3"]))
            }
        }

        describe("map") {
            it("returns array of values at key path") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: false),
                    TestElement(id: 1, name: "One", isActive: true)
                ].map(\.name))
                .to(equal(["Zero", "One"]))
            }
        }

        describe("prefix(while:)") {
            it("returns subsequence of elements with true values") {
                expect([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: nil, isActive: false)
                ].prefix(while: \.isActive))
                .to(equal([TestElement(id: 0, name: "Zero", isActive: true)]))
            }
        }

        describe("sorted(by:)") {
            it("returns elements sorted by value") {
                expect([
                    TestElement(id: 1, name: "One", isActive: true),
                    TestElement(id: 0, name: "Zero", isActive: true)
                ].sorted(by: \.id))
                .to(equal([
                    TestElement(id: 0, name: "Zero", isActive: true),
                    TestElement(id: 1, name: "One", isActive: true)
                ]))
            }
        }
    }
}

struct TestElement: Equatable {
    let id: Int
    let name: String?
    let isActive: Bool
    let tags: [String]

    init(id: Int, name: String?, isActive: Bool, tags: [String] = []) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.tags = tags
    }
}
