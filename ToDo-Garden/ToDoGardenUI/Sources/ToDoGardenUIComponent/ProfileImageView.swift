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
  private let size: CGSize
  private var imageLoadTask: Task<(), Never>?

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

    self.imageLoadTask = self.createImageLoadTask(with: image)
  }

  deinit {
    self.imageLoadTask?.cancel()
  }
}

extension ProfileImageView {
  private func setupDefaultImage() {
    let defaultImage = self.size == Constant.ProfileImageView.Size.small ?
    UIImage.defaultFriendProfileImage : UIImage.defaultProfileImage

    self.imageLoadTask = self.createImageLoadTask(with: defaultImage)
  }

  private func createImageLoadTask(with image: UIImage) -> Task<(), Never> {
    return Task { [weak self] in
      guard let self = self else { return }

      if let resizedImage = await image.byPreparingThumbnail(ofSize: self.size) {
        self.image = resizedImage
      } else {
        self.image = image
      }
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
