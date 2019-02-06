//
//  UIImage+AstroGadgets.swift
//  Astro
//
//  Created by Teressa Eid on 11/30/18.
//  Copyright © 2018 Robots and Pencils. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /** Resizes an image to a given width, preserving aspect ratio */
    public func resizeImage(forWidth: CGFloat) -> UIImage {
        let scale = forWidth / self.size.width
        let height = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: forWidth, height: height))
        self.draw(in: CGRect(x: 0, y: 0, width: forWidth, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /** Returns a drawn image with a given color and size. */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
