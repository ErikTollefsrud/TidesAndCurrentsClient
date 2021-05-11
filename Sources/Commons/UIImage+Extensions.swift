//
//  UIImage+Extensions.swift
//
//  Created by Klajd Deda on 1/16/21.
//  Copyright © 2021 id-design. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    func shrink(by: Int) -> UIImage? {
        let scaledSize = CGSize(width: self.size.width/4, height: self.size.height/4)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: scaledSize, format: format)

        Commons.log("scaledSize: \(scaledSize)")
        let scaledImage = renderer.image { (context) in
            self.draw(in: CGRect(
                origin: CGPoint(
                    x: 0,
                    y: 0
                ),
                size: scaledSize
            ))
        }
        Commons.log(" finalSize: \(scaledImage.size)")
        Commons.log("---")
        return scaledImage
    }

    func scaledByAspectFill(newSize: CGSize) -> UIImage? {
        let scaledSize = self.size.croppedByAspectRatio(newSize.width / newSize.height)
        let newOrigin = CGPoint(
            x: (self.size.width - scaledSize.width) / 2.0,
            y: (self.size.height - scaledSize.height) / 2.0
        )
        
        Commons.log("  existing: \(self.size)")
        Commons.log(" newOrigin: \(newOrigin)")
        Commons.log("scaledSize: \(scaledSize)")
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: scaledSize, format: format)
        
        let scaledImage = renderer.image { (context) in
            self.draw(in: CGRect(
                origin: CGPoint(
                    x: 0,
                    y: -newOrigin.y
                ),
                size: self.size
            ))
        }
        
        Commons.log(" finalSize: \(scaledImage.size)")
        Commons.log("---")
        // return scaledImage
        return scaledImage.shrink(by: 3)
    }
}

extension CGSize {
    fileprivate func croppedByAspectRatio(_ newRatio: CGFloat) -> CGSize {
        var rv: CGSize = CGSize.zero
        let existingRatio = width / height

        if (newRatio < existingRatio) {
            rv.width  = height * newRatio
            rv.height = height
        }
        else {
            rv.width  = width
            rv.height = width / newRatio
        }
        return rv
    }
}
