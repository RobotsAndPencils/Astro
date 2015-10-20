//
//  UIViewControllerAstroGadgets.swift
//  Astro
//
//  Created by Dominic Pepin on 2015-04-29.
//  Copyright (c) 2015 Robots and Pencils Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  "RoboKit" is a trademark of Robots and Pencils, Inc. and may not be used to endorse or promote products derived from this software without specific prior written permission.
//
//  Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

public extension UIViewController {
    
    // MARK: General
    
    /**
    Ensure that a view controller is added properly to another view controller
    */
    public func addChildViewController(childViewController: UIViewController, inContainer view: UIView) {
        self.addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMoveToParentViewController(self)
    }
}


public extension UIViewController {
    
    // MARK: Alerts
    
    /**
    Shorten way to prompt an alert
    */
    public func quickAlert(title title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
    Prompts an alert indicating that the feature has not been implemented
    */
    public func featureNotImplemented() {
        NSLog("FEATURE NOT IMPLEMENTED")
        quickAlert(title: "Coming Soon", message: "Feature Not Implemented Yet.")
    }
}
