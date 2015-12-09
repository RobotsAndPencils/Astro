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
            var testKey = "key"
            
            afterEach {
                keychain.delete(testKey)
            }
            
            it("returns nil for retrieving a key that doesn't exist") {
                testKey = "notValidKey"
                let storedString = keychain.getString(testKey)
                expect(storedString).to(beNil())
            }

            it("can store and retrieve a string") {
                testKey = "string"
                let testString = "something really boring"
                keychain.putString(testKey, value: testString)
                
                let storedString = keychain.getString(testKey)
                expect(storedString).to(equal(testString))
            }
            
            it("can store and retrieve data") {
                testKey = "data"
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
                testKey = "string"
                keychain.putString(testKey, value: nil)
                
                let storedString = keychain.getString(testKey)
                expect(storedString).to(beNil())
            }
            
            it("can set a data value to nil") {
                testKey = "data"
                keychain.putString(testKey, value: nil)
                
                let storedData = keychain.get(testKey)
                expect(storedData).to(beNil())
            }
            
            it("can be accessed using subscripting for strings") {
                testKey = "string"
                let testString = "something slightly less boring"
                keychain[testKey] = testString
                
                let storedString = keychain[testKey]
                expect(storedString).to(equal(testString))
            }
            
            it("can be accessed using subscripting for data") {
                testKey = "data"
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
                testKey = "string"
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
                testKey = "string"
                let testString = "exciting stuff?"
                keychain.putString(testKey, value: testString)
                let storedString = keychain.getString(testKey)
                keychain.putString(testKey, value: nil)
                
                let storedNil = keychain.getString(testKey)
                expect(storedString).to(equal(testString))
                expect(storedNil).to(beNil())
            }
            
        }
        
    }
    
}
