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

class KeychainAccessSpec: QuickSpec {
    
    override func spec() {

        describe("A keychain") {
            let keychain = KeychainAccess(account: "Test@RobotsAndPencils.com")
            var testKey = "AccessKey"
            
            afterEach {
                _ = keychain.delete(testKey, accessibleAttribute: .WhenUnlocked)
            }

            context("and you want it available when unlocked") {

                it("returns nil for retrieving a key that doesn't exist") {
                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(beNil())
                }

                it("can store and retrieve a string") {
                    let testString = "something really boring"
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlocked)

                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(equal(testString))
                }

                it("can store and retrieve data") {
                    testKey = "DataKey"
                    guard let testFilePath = Bundle(for: KeychainAccessSpec.self).url(forResource: "testdata", withExtension: "json") else {
                        fail("no test file")
                        return
                    }
                    let testData = try! Data(contentsOf: testFilePath)
                    _ = keychain.put(testKey, data: testData, accessibleAttribute: .WhenUnlocked)

                    let storedData = keychain.get(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedData).toNot(beNil())
                    expect(storedData).to(equal(testData))
                }

                it("can set a string value to nil") {
                    _ = keychain.putString(testKey, value: nil, accessibleAttribute: .WhenUnlocked)

                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(beNil())
                }

                it("can set a data value to nil") {
                    _ = keychain.putString(testKey, value: nil, accessibleAttribute: .WhenUnlocked)

                    let storedData = keychain.get(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedData).to(beNil())
                }

                it("can be accessed using subscripting for strings") {
                    let testString = "something slightly less boring"
                    keychain[testKey] = testString

                    let storedString = keychain[testKey]
                    expect(storedString).to(equal(testString))
                }

                it("can be accessed using subscripting for data") {
                    testKey = "DataKey"
                    guard let testFilePath = Bundle(for: KeychainAccessSpec.self).url(forResource: "testdata", withExtension: "json") else {
                        fail("no test file")
                        return
                    }
                    let testData = try! Data(contentsOf: testFilePath)
                    keychain[data: testKey] = testData

                    let storedData = keychain[data: testKey]
                    expect(storedData).toNot(beNil())
                    expect(storedData).to(equal(testData))
                }

                it("can override a value") {
                    let origString = "exciting stuff?"
                    let finalString = "boring stuff?"

                    _ = keychain.putString(testKey, value: origString, accessibleAttribute: .WhenUnlocked)
                    let storedOrigString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedOrigString).to(equal(origString))

                    _ = keychain.putString(testKey, value: finalString, accessibleAttribute: .WhenUnlocked)
                    let storedFinalString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedFinalString).to(equal(finalString))
                }

                it("can delete a value") {
                    let testString = "exciting stuff?"
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlocked)
                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    _ = keychain.putString(testKey, value: nil, accessibleAttribute: .WhenUnlocked)

                    let storedNil = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(equal(testString))
                    expect(storedNil).to(beNil())
                }

                it("can delete all keys and data for the app") {
                    // Push in a key/data element and verify it exists
                    let testString = "exciting stuff?"
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlocked)
                    var storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(equal(testString))

                    // Delete everything and then verify you can't access the key/data any more
                    let status = keychain.deleteAllKeysAndDataForApp()
                    expect(status).to(beTrue())
                    storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(beNil())
                }

                it("can't access a key from a different account") {
                    testKey = "SuperSecretKey"
                    let testString = "you can't see me"

                    // Push in a key/data element and verify it exists in the main account
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlocked)
                    var storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(equal(testString))
                    
                    // Try to gain access to a key from another account
                    let otherKeychain = KeychainAccess(account: "SomeOtherAccount@RobotsAndPencils.com")
                    storedString = otherKeychain.getString(testKey, accessibleAttribute: .WhenUnlocked)
                    expect(storedString).to(beNil())
                }
            }

            context("and you want it just on that device") {

                it("can store and retrieve a string") {
                    let testString = "something really boring"
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlockedThisDeviceOnly)

                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(equal(testString))
                }

                it("can store and retrieve data") {
                    testKey = "DataKey"
                    guard let testFilePath = Bundle(for: KeychainAccessSpec.self).url(forResource: "testdata", withExtension: "json") else {
                        fail("no test file")
                        return
                    }
                    let testData = try! Data(contentsOf: testFilePath)
                    _ = keychain.put(testKey, data: testData, accessibleAttribute: .WhenUnlockedThisDeviceOnly)

                    let storedData = keychain.get(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedData).toNot(beNil())
                    expect(storedData).to(equal(testData))
                }

                it("can set a string value to nil") {
                    _ = keychain.putString(testKey, value: nil, accessibleAttribute: .WhenUnlockedThisDeviceOnly)

                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(beNil())
                }

                it("can set a data value to nil") {
                    _ = keychain.putString(testKey, value: nil, accessibleAttribute: .WhenUnlockedThisDeviceOnly)

                    let storedData = keychain.get(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedData).to(beNil())
                }

                it("can override a value") {
                    let origString = "exciting stuff?"
                    let finalString = "boring stuff?"

                    _ = keychain.putString(testKey, value: origString, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    let storedOrigString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedOrigString).to(equal(origString))

                    _ = keychain.putString(testKey, value: finalString, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    let storedFinalString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedFinalString).to(equal(finalString))
                }

                it("can delete a value") {
                    let testString = "exciting stuff?"
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    let storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    _ = keychain.putString(testKey, value: nil, accessibleAttribute: .WhenUnlockedThisDeviceOnly)

                    let storedNil = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(equal(testString))
                    expect(storedNil).to(beNil())
                }

                it("can delete all keys and data for the app") {
                    // Push in a key/data element and verify it exists
                    let testString = "exciting stuff?"
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    var storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(equal(testString))

                    // Delete everything and then verify you can't access the key/data any more
                    let status = keychain.deleteAllKeysAndDataForApp()
                    expect(status).to(beTrue())
                    storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(beNil())
                }

                it("can't access a key from a different account") {
                    testKey = "SuperSecretKey"
                    let testString = "you can't see me"

                    // Push in a key/data element and verify it exists in the main account
                    _ = keychain.putString(testKey, value: testString, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    var storedString = keychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(equal(testString))
                    
                    // Try to gain access to a key from another account
                    let otherKeychain = KeychainAccess(account: "SomeOtherAccount@RobotsAndPencils.com")
                    storedString = otherKeychain.getString(testKey, accessibleAttribute: .WhenUnlockedThisDeviceOnly)
                    expect(storedString).to(beNil())
                }
            }
        }

        describe("A KeychainAccessibleAttribute") {

            context("when unlocked") {
                let attribute = KeychainAccessibleAttribute.WhenUnlocked
                it("should return kSecAttrAccessibleWhenUnlocked") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleWhenUnlocked)))
                }
            }

            context("when after first unlock") {
                let attribute = KeychainAccessibleAttribute.AfterFirstUnlock
                it("should return kSecAttrAccessibleAfterFirstUnlock") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleAfterFirstUnlock)))
                }
            }

            context("when always") {
                let attribute = KeychainAccessibleAttribute.Always
                it("should return kSecAttrAccessibleAlways") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleAlways)))
                }
            }

            context("when passcode set this device only") {
                let attribute = KeychainAccessibleAttribute.WhenPasscodeSetThisDeviceOnly
                it("should return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)))
                }
            }

            context("when unlocked this device only") {
                let attribute = KeychainAccessibleAttribute.WhenUnlockedThisDeviceOnly
                it("should return kSecAttrAccessibleWhenUnlockedThisDeviceOnly") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)))
                }
            }

            context("when after first unlock this device only") {
                let attribute = KeychainAccessibleAttribute.AfterFirstUnlockThisDeviceOnly
                it("should return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)))
                }
            }

            context("when always this device only") {
                let attribute = KeychainAccessibleAttribute.AlwaysThisDeviceOnly
                it("should return kSecAttrAccessibleAlwaysThisDeviceOnly") {
                    expect(String(attribute.secAttrValue())).to(equal(String(kSecAttrAccessibleAlwaysThisDeviceOnly)))
                }
            }
        }
    }
    
}
