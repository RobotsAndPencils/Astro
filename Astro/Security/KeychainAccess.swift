//
//  KeychainAccess.swift
//  Astro
//
//  Created by Colin Gislason on 2015-10-14.
//  Copyright © 2015 Robots and Pencils Inc. All rights reserved.
//

import Foundation
import Security

let KeychainAccessServiceBundleID: String = {
    if NSClassFromString("XCTestCase") != nil {
        return "com.robotsandpencils.TestTarget"
    }
    else {
        return NSBundle.mainBundle().bundleIdentifier ?? ""
    }
}()

let KeychainAccessErrorDomain = "\(KeychainAccessServiceBundleID).error"

class KeychainAccess {
    
    let keychainAccessAccount: String?
    
    init(account: String) {
        keychainAccessAccount = account
    }
    
    /**
        Retrieve a string for the given key.
    
        - parameter key: the key to find the string in the keychain
        - returns: the value stored for that key as a string. nil if there is no value or the value is not a string
    */
    func getString(key: String) -> String? {
        guard let data = self.get(key) else {
            return nil
        }
        return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
    
    /**
        Retrieve data for the given key.
    
        - parameter key: the key to find the data in the keychain
        - returns: the value stored for that key as NSData. nil if there is no value or the value is not NSData
    */
    func get(key: String) -> NSData? {
        let query = self.query(key, get: true)
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            guard let data = result as? NSData else {
                Log.warn("No data fetched for the key from keychain with status=\(status). Attempted to get value for key [\(key)]")
                return nil
            }
            return data
        } else {
            Log.warn("Failed to fetch value from keychain with status=\(status).Attempted to get value for key [\(key)]")
            return nil
        }
    }
    
    /**
        Set a string for the given key.
        
        - parameter key: the key to store the string for in the keychain
        - parameter value: the string to store in the keychain
        - returns: true if the store was successful, false if there was an error
    */
    func putString(key: String, value: String?) -> Bool {
        return self.put(key, data: value?.dataUsingEncoding(NSUTF8StringEncoding))
    }
    
    /**
        Set data for the given key.
        
        - parameter key: the key to store the data for in the keychain
        - parameter value: the data to store in the keychain
        - returns: true if the store was successful, false if there was an error
    */
    func put(key: String, data: NSData?) -> Bool {
        let query = self.query(key, value: data)
        // TODO: Convert this to attempt to update (watch out its tricky!)
        var status = SecItemDelete(query)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            status = SecItemAdd(query, nil)
            if status != errSecSuccess {
                Log.warn("Failed to add data to keychain with status=\(status). Attempted to add data [\(data)] for key [\(key)]")
                return false
            }
            return true
        } else {
            Log.warn("Failed to add key to keychain with status=\(status). Attempted to add key [\(key)]")
            return false
        }
    }
    
    /**
        Delete the data for the given key.
        
        - parameter key: the key to delete the data for in the keychain
        - returns: true if the delete was successful, false if there was an error
    */
    func delete(key: String) -> Bool {
        let query = self.query(key)
        let status = SecItemDelete(query)

        if status == errSecSuccess || status == errSecItemNotFound {
            return true
        } else {
            Log.warn("Failed to delete key from keychain with status=\(status). Attempted to delete key [\(key)]")
            return false
        }
    }

    /**
        Set up the query for use with the keychain functions.
        
        - parameter key: the key to use for searching or saving
        - parameter value: the data to store in the keychain
        - parameter get: the query is for retrieving data and should have the parameters to do that
        - returns: a dictionary for use as the query
    */
    private func query(key: String? = nil, value: AnyObject? = nil, get: Bool = false) -> CFDictionaryRef {
        var query: [String: AnyObject] = [:]
        query[kSecAttrService as String] = KeychainAccessServiceBundleID
        query[kSecAttrAccount as String] = self.keychainAccessAccount
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecClass as String] = kSecClassGenericPassword
        if let key = key {
            query[kSecAttrAccount as String] = key
        }
        if let value = value {
            query[kSecValueData as String] = value
        }
        if get {
            query[kSecReturnData as String] = kCFBooleanTrue
            query[kSecMatchLimit as String] = kSecMatchLimitOne
        }
        return query as CFDictionaryRef
    }
    
    subscript(key: String) -> String? {
        get {
            return self.getString(key)
        }
        
        set {
            self.putString(key, value: newValue)
        }
    }
    
    subscript(data key: String) -> NSData? {
        get {
            return self.get(key)
        }
        
        set {
            self.put(key, data: newValue)
        }
    }
}
