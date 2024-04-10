//
//  ProfileImageView.swift
//
//
//  Created by Wood on 4/7/24.
//

import UIKit.UIImageView

public final class ProfileImageView: UIImageView {
  private var size: CGSize

  public init(size: CGSize) {
    self.size = size
    super.init(frame: CGRect.zero)
    ProfileImageViewStyle.apply(to: self, with: self.size)
  }

  required init?(coder: NSCoder) {
    self.size = CGSize()
    super.init(coder: coder)
    ProfileImageViewStyle.apply(to: self, with: self.size)
  }
}

private enum ProfileImageViewStyle {
  fileprivate static func apply(to imageView: UIImageView, with size: CGSize) {
    self.setupRoundedCorner(to: imageView, with: size)
    self.setupContentAppearnce(to: imageView)
  }
}

extension ProfileImageViewStyle {
  private static func setupRoundedCorner(to imageView: UIImageView, with size: CGSize) {
    imageView.layer.cornerRadius = size.height / 2
  }
  
  private static func setupContentAppearnce(to imageView: UIImageView) {
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.clipsToBounds = true
  }
}
