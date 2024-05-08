//
//  ToDoGardenPlainButton.swift
//
//
//  Created by Wood on 4/18/24.
//

import UIKit.UIButton

public final class ToDoGardenPlainButton: UIButton {
  private var model: Model

  public init(model: Model) {
    self.model = model
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension ToDoGardenPlainButton {
  private func setup() {
    self.setupConfiguration()
    self.setupImage()
  }

  private func setupConfiguration() {
    let configuration = UIButton.Configuration.plain()
    self.configuration = configuration
  }

  private func setupImage() {
    self.configuration?.image = self.model.image
  }
}

// MARK: Model

extension ToDoGardenPlainButton {
  public struct Model {
    let image: UIImage

    init(image: UIImage) {
      self.image = image
    }
  }
}
