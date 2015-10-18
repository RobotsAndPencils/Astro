//
//  UIViewControllerAstroGadgets.swift
//  PriorityMoments
//
//  Created by Dominic Pepin on 2015-04-29.
//  Copyright (c) 2015 Robots and Pencils Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addChildViewController(childViewController: UIViewController, inView view: UIView) {
        self.addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMoveToParentViewController(self)
    }
}


extension UIViewController {
    
    // MARK: Alerts
    
    /**
    Shorten way to prompt an alert
    */
    func quickAlert(title title: String?, message: String?) {
        if classExists("UIAlertController") {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    /**
    Prompts an alert indicating that the feature has not been implemented
    */
    func featureNotImplemented() {
        OPMLogger.debug("FEATURE_NOT_IMPLEMENTED")
        quickAlert(title: "Coming Soon", message: "Feature Not Implemented Yet.")
    }
}