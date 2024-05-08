//
//  ToDoGardenPlainButtonGenerator.swift
//
//
//  Created by Wood on 4/18/24.
//

import UIKit.UIButton

public struct ToDoGardenPlainButtonGenerator {
  private var model: Model

  public init(model: Model) {
    self.model = model
  }

  public func generate() -> UIButton {
    let button = UIButton(configuration: UIButton.Configuration.plain())
    self.setupImage(to: button)
    return button
  }
}

// MARK: Private Functions

extension ToDoGardenPlainButtonGenerator {
  private func setupImage(to button: UIButton) {
    button.configuration?.image = self.model.image
  }
}

// MARK: Model

extension ToDoGardenPlainButtonGenerator {
  public struct Model {
    let image: UIImage

    public init(image: UIImage) {
      self.image = image
    }
  }
}

// MARK: Preview

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let button = ToDoGardenPlainButtonGenerator(
    model: ToDoGardenPlainButtonGenerator.Model(
      image: UIImage.forwardButtonImage
    )
  ).generate()
  return button
}
#endif
