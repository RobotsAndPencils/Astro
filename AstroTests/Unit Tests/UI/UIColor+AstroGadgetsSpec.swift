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

class UIColor_AstroGadgetsSpec: QuickSpec {
    override func spec() {
        describe("init(hexColor:)") {
            var hexString: String!

            context("00") {
                it("returns nil") {
                    hexString = "00"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(beNil())
                }
            }

            context("AABBCC") {
                it("correctly deserializes the color") {
                    hexString = "AABBCC"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(equal(UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0xFF/255.0)))
                }
            }

            context("aabbcc") {
                it("correctly deserializes the color") {
                    hexString = "aabbcc"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(equal(UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0xFF/255.0)))
                }
            }

            context("000000") {
                it("correctly deserializes the color") {
                    hexString = "000000"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(equal(UIColor(red: 0x00/255.0, green: 0x00/255.0, blue: 0x00/255.0, alpha: 0xFF/255.0)))
                }
            }

            context("#000000") {
                it("correctly deserializes the color") {
                    hexString = "#000000"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(equal(UIColor(red: 0x00/255.0, green: 0x00/255.0, blue: 0x00/255.0, alpha: 0xFF/255.0)))
                }
            }

            context("123456") {
                it("correctly deserializes the color") {
                    hexString = "123456"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(equal(UIColor(red: 0x12/255.0, green: 0x34/255.0, blue: 0x56/255.0, alpha: 0xFF/255.0)))
                }
            }

            context("AABBCCDD") {
                it("correctly deserializes the color") {
                    hexString = "AABBCCDD"
                    let subject = UIColor(hexString: hexString)
                    expect(subject).to(equal(UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0xDD/255.0)))
                }
            }
        }

        describe("hexRGB()") {
            context("AABBCC") {
                it("correctly serializes the color") {
                    let subject = UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0xDD/255.0).hexRGB()
                    expect(subject).to(equal("AABBCC"))
                }
            }
            
            context("AABBCC") {
                it("correctly serializes the color") {
                    let subject = UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0x00/255.0).hexRGB()
                    expect(subject).to(equal("AABBCC"))
                }
            }
            
            context("000000") {
                it("correctly serializes the color") {
                    let subject = UIColor(red: 0x00/255.0, green: 0x00/255.0, blue: 0x00/255.0, alpha: 0xFF/255.0).hexRGB()
                    expect(subject).to(equal("000000"))
                }
            }
            
            context("01AF97") {
                it("correctly serializes the color with alpha") {
                    let subject = UIColor(red: 0x01/255.0, green: 0xAF/255.0, blue: 0x97/255.0, alpha: 0x00/255.0).hexRGB()
                    expect(subject).to(equal("01AF97"))
                }
            }
        }

        describe("hexRGBA()") {
            context("AABBCCDD") {
                it("correctly serializes the color with alpha") {
                    let subject = UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0xDD/255.0).hexRGBA()
                    expect(subject).to(equal("AABBCCDD"))
                }
            }

            context("AABBCC00") {
                it("correctly serializes the color with alpha") {
                    let subject = UIColor(red: 0xAA/255.0, green: 0xBB/255.0, blue: 0xCC/255.0, alpha: 0x00/255.0).hexRGBA()
                    expect(subject).to(equal("AABBCC00"))
                }
            }
        }
    }
}
