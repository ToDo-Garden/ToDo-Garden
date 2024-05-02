//
//  CreateToDoButton.swift
//
//
//  Created by Wood on 5/2/24.
//

import UIKit

import ToDoGardenUIResource

public final class CreateToDoButton: UIButton {
  private var primaryModel: CreateToDoButton.PrimaryModel

  public init(primaryModel: CreateToDoButton.PrimaryModel) {
    self.primaryModel = primaryModel
    super.init(frame: CGRect.zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Primary Model

extension CreateToDoButton {
  public struct PrimaryModel {
    var title: String
    var imagePadding: CGFloat
    var contentInsets: NSDirectionalEdgeInsets
    var image: UIImage

    public init(
      title: String,
      imagePadding: CGFloat = Constant.CreateToDoButton.Layout.Primary.imagePadding,
      contentInsets: NSDirectionalEdgeInsets = Constant.CreateToDoButton.Layout.Primary.contentInsets,
      image: UIImage = UIImage.createToDoButtonImage
    ) {
      self.title = title
      self.imagePadding = imagePadding
      self.contentInsets = contentInsets
      self.image = image
    }
  }
}
