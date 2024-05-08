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
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ToDoGardenPlainButton {
  public struct Model {
    let image: UIImage

    init(image: UIImage) {
      self.image = image
    }
  }
}
