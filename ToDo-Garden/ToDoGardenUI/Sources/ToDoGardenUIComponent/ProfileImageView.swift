//
//  ProfileImageView.swift
//
//
//  Created by Wood on 4/7/24.
//

import UIKit.UIImageView

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class ProfileImageView: UIImageView {
  private var size: CGSize
  private var imageLoadTask: Task<(), Error>?

  public init(size: CGSize) {
    self.size = size
    super.init(frame: CGRect.zero)
    ProfileImageViewStyle.apply(to: self, with: self.size)
    self.setupDefaultImage()
  }

  required init?(coder: NSCoder) {
    self.size = CGSize()
    super.init(coder: coder)
    ProfileImageViewStyle.apply(to: self, with: self.size)
    self.setupDefaultImage()
  }

  public func setupImage(with image: UIImage) {
    guard self.imageLoadTask == nil || self.imageLoadTask?.isCancelled == false
    else { return }

    self.imageLoadTask = Task { [weak self] in
      guard let self else { return }

      if let preparedImage = await image.byPreparingThumbnail(ofSize: self.size) {
        self.image = preparedImage
      }
    }
  }

  deinit {
    self.imageLoadTask?.cancel()
  }
}

extension ProfileImageView {
  private func setupDefaultImage() {
    if self.size == Constant.ProfileImageView.Size.small {
      self.setupImage(with: UIImage.defaultFriendProfileImage)
    } else {
      self.setupImage(with: UIImage.defaultProfileImage)
    }
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
