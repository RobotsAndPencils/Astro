//
//  Array+AstroGadgets.swift
//  Astro
//
//  Created by Teressa Eid on 11/30/18.
//  Copyright © 2018 Robots and Pencils. All rights reserved.
//

import Foundation

public extension Array {
    /**
     A safe version of subscript does automatic bounds checking. Takes an optional index and returns an optional object.
     
     - parameter safe: the index of the object in the array. Passing nil will always return nil.
     - returns: The object at the index or nil if the index is nil or out of bounds.
     */
    subscript (safe index: Int?) -> Element? {
        if let index = index {
            return 0 <= index && index < self.count ? self[index] : nil
        }
        return nil
    }
    
    var random: Element {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
    
}

public extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
