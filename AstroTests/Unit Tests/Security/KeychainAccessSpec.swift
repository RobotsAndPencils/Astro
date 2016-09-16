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
        
    /**
     NOTE: Unit tests will fail for the KeychainAccessSpec due to the an issue around Keychain entitlements (https://forums.developer.apple.com/thread/51071).
     Radar's have been filed by the looks of it so now its just a waiting game until those tests will clear.
         
        describe("A keychain") {
            let keychain = KeychainAccess(account: "Test@RobotsAndPencils.com")
            var testKey = "AccessKey"
            
            afterEach {
                keychain.delete(testKey)
            }
            
            it("returns nil for retrieving a key that doesn't exist") {
                let storedString = keychain.getString(testKey)
                expect(storedString).to(beNil())
            }

            it("can store and retrieve a string") {
                let testString = "something really boring"
                keychain.putString(testKey, value: testString)
                
                let storedString = keychain.getString(testKey)
                expect(storedString).to(equal(testString))
            }
            
            it("can store and retrieve data") {
                testKey = "DataKey"
                guard let testFilePath = NSBundle(forClass: KeychainAccessSpec.self).pathForResource("testdata", ofType: "json") else {
                    fail("no test file")
                    return
                }
                let testData = NSData(contentsOfFile: testFilePath)
                keychain.put(testKey, data: testData)
                
                let storedData = keychain.get(testKey)
                expect(storedData).toNot(beNil())
                expect(storedData).to(equal(testData))
            }
            
            it("can set a string value to nil") {
                keychain.putString(testKey, value: nil)
                
                let storedString = keychain.getString(testKey)
                expect(storedString).to(beNil())
            }
            
            it("can set a data value to nil") {
                keychain.putString(testKey, value: nil)
                
                let storedData = keychain.get(testKey)
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
                guard let testFilePath = NSBundle(forClass: KeychainAccessSpec.self).pathForResource("testdata", ofType: "json") else {
                    fail("no test file")
                    return
                }
                let testData = NSData(contentsOfFile: testFilePath)
                keychain[data: testKey] = testData
                
                let storedData = keychain[data: testKey]
                expect(storedData).toNot(beNil())
                expect(storedData).to(equal(testData))
            }
            
            it("can override a value") {
                let origString = "exciting stuff?"
                let finalString = "boring stuff?"

                keychain.putString(testKey, value: origString)
                let storedOrigString = keychain.getString(testKey)
                expect(storedOrigString).to(equal(origString))
                
                keychain.putString(testKey, value: finalString)
                let storedFinalString = keychain.getString(testKey)
                expect(storedFinalString).to(equal(finalString))
            }

            it("can delete a value") {
                let testString = "exciting stuff?"
                keychain.putString(testKey, value: testString)
                let storedString = keychain.getString(testKey)
                keychain.putString(testKey, value: nil)
                
                let storedNil = keychain.getString(testKey)
                expect(storedString).to(equal(testString))
                expect(storedNil).to(beNil())
            }

            it("can delete all keys and data for the app") {
                // Push in a key/data element and verify it exists
                let testString = "exciting stuff?"
                keychain.putString(testKey, value: testString)
                var storedString = keychain.getString(testKey)
                expect(storedString).to(equal(testString))

                // Delete everything and then verify you can't access the key/data any more
                let status = keychain.deleteAllKeysAndDataForApp()
                expect(status).to(beTrue())
                storedString = keychain.getString(testKey)
                expect(storedString).to(beNil())
            }

            it("can't access a key from a different account") {
                testKey = "SuperSecretKey"
                let testString = "you can't see me"

                // Push in a key/data element and verify it exists in the main account
                keychain.putString(testKey, value: testString)
                var storedString = keychain.getString(testKey)
                expect(storedString).to(equal(testString))
                
                // Try to gain access to a key from another account
                let otherKeychain = KeychainAccess(account: "SomeOtherAccount@RobotsAndPencils.com")
                storedString = otherKeychain.getString(testKey)
                expect(storedString).to(beNil())
            }

        }
        
    */
    }
    
}
