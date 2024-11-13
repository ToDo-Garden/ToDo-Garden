//
//  UIImage+Resizing.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

public extension UIImage {
  func resizedImage(targetSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(targetSize, false, CGFloat.zero)
    self.draw(in: CGRect(origin: .zero, size: targetSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
