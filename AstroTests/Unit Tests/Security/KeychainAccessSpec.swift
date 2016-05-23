//
//  KeychainAccessSpec.swift
//  Astro
//
//  Created by Colin Gislason on 2015-10-03.
//  Copyright (c) 2015 Robots and Pencils Inc. All rights reserved.
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
        
    }
    
}
