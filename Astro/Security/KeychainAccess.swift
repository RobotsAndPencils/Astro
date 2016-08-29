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

import Foundation
import Security

let KeychainAccessServiceBundleID: String = {
    if NSClassFromString("XCTestCase") != nil {
        Log.level = Log.Level.Debug
        return "com.robotsandpencils.TestTarget"
    } else {
        return NSBundle.mainBundle().bundleIdentifier ?? ""
    }
}()

let KeychainAccessErrorDomain = "\(KeychainAccessServiceBundleID).error"

/**
 KeychainAccess provides the app access to a device's Keychain store. Usage is fairly straightforward, as part of an account, you can place strings (or data) for a key into the Keychain and then retrieve those values later. This makes it a good way to securely store a specific user's password or tokens for reuse in the app.
 */
public class KeychainAccess {
    
    let keychainAccessAccount: String?
    
    /**
     Initialize a new instance of KeychainAccess given a unique account identifier
     
     - parameter account: the account for which the keys will be appended in the keychain
     */
    public init(account: String) {
        keychainAccessAccount = account
    }
    
    /**
       Retrieve a string for the given key.
    
       - parameter key: the key to find the string in the keychain
       - returns: the value stored for that key as a string. nil if there is no value or the value is not a string
    */
    public func getString(key: String) -> String? {
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
    public func get(key: String) -> NSData? {
        let query = self.query(key, get: true)
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            guard let data = result as? NSData else {
                Log.debug("No data fetched for the key from keychain with status=\(status). Attempted to get value for key [\(key)]")
                return nil
            }
            return data
        } else {
            Log.debug("Failed to fetch value from keychain with status=\(status).Attempted to get value for key [\(key)]")
            return nil
        }
    }
    
    /**
       Set a string for the given key.
        
       - parameter key: the key to store the string for in the keychain
       - parameter value: the string to store in the keychain (if nil then no data will be stored for the key)
       - returns: true if the store was successful, false if there was an error
    */
    public func putString(key: String, value: String?) -> Bool {
        return self.put(key, data: value?.dataUsingEncoding(NSUTF8StringEncoding))
    }
    
    /**
       Set data for the given key.
        
       - parameter key: the key to store the data for in the keychain
       - parameter value: the data to store in the keychain (if nil then no data will be stored for the key)
       - returns: true if the store was successful, false if there was an error
    */
    public func put(key: String, data: NSData?) -> Bool {
        let query = self.query(key, value: data)
        var result: AnyObject?
        
        var status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            // Key previously existed
            if let data = data {
                // Updating the data to a new value
                let attributesToUpdate: [String: AnyObject] = [kSecValueData as String : data]
                status = SecItemUpdate(query, attributesToUpdate as CFDictionaryRef)
                if status == errSecSuccess {
                    return true
                }
                Log.debug("Failed to update data in keychain with status=\(status). Attempted to update data [\(data)] for key [\(key)]")
                return false
            } else {
                // Explicitly clearing the old data since we can't update to a nil value
                var status = SecItemDelete(query)
                if status == errSecSuccess {
                    status = SecItemAdd(query, nil)
                    if status == errSecSuccess {
                        return true
                    }
                }
                Log.debug("Failed to clear data in keychain with status=\(status). Attempted to clear data for key [\(key)]")
                return false
            }
        } else if status == errSecItemNotFound {
            // Key doesn't exist so add it
            status = SecItemAdd(query, nil)
            if status == errSecSuccess {
                return true
            }
            Log.debug("Failed to add data to keychain with status=\(status). Attempted to add data [\(data)] for key [\(key)]")
            return false
        } else {
            Log.debug("Failed to add key to keychain with status=\(status). Attempted to add key [\(key)]")
            return false
        }
    }
    
    /**
       Delete the data for the given key.
        
       - parameter key: the key to delete the data for in the keychain
       - returns: true if the delete was successful, false if there was an error
    */
    public func delete(key: String) -> Bool {
        let query = self.query(key)
        let status = SecItemDelete(query)

        if status == errSecSuccess || status == errSecItemNotFound {
            return true
        } else {
            Log.debug("Failed to delete key from keychain with status=\(status). Attempted to delete key [\(key)]")
            return false
        }
    }

    /**
       Delete all keys and data for the app.
     
       - returns: true if the delete was successful, false if there was an error
     */
    public func deleteAllKeysAndDataForApp() -> Bool {
        var query: [String: AnyObject] = [:]
        query[kSecClass as String] = kSecClassGenericPassword
        
        let status = SecItemDelete(query)
        if status == errSecSuccess || status == errSecItemNotFound {
            return true
        } else {
            Log.debug("Failed to delete all app keys and data from keychain with status=\(status).")
            return false
        }
    }

    public subscript(key: String) -> String? {
        get {
            return self.getString(key)
        }

        set {
            self.putString(key, value: newValue)
        }
    }

    public subscript(data key: String) -> NSData? {
        get {
            return self.get(key)
        }

        set {
            self.put(key, data: newValue)
        }
    }

    //MARK: Private
    /**
       Set up the query for use with the keychain functions.
        
       - parameter key: the key to use for searching or saving
       - parameter value: the data to store in the keychain
       - parameter get: the query is for retrieving data and should have the parameters to do that
       - returns: a dictionary for use as the query
    */
    private func query(key: String, value: AnyObject? = nil, get: Bool = false) -> CFDictionaryRef {
        var query: [String: AnyObject] = [:]
        query[kSecAttrService as String] = key
        query[kSecAttrAccount as String] = self.keychainAccessAccount
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecClass as String] = kSecClassGenericPassword
        
        if let value = value {
            query[kSecValueData as String] = value
        }
        
        if get {
            query[kSecReturnData as String] = kCFBooleanTrue
            query[kSecMatchLimit as String] = kSecMatchLimitOne
        }
        
        return query as CFDictionaryRef
    }
    
}
