//
//  Bundle+AstroGadgets.swift
//  Astro
//
//  Created by Teressa Eid on 11/30/18.
//  Copyright © 2018 Robots and Pencils. All rights reserved.
//

import Foundation

public extension Bundle {
    
    var shortVersionString: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var bundleVersion: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
}
