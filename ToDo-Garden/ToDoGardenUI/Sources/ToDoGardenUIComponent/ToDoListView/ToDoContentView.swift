//
//  ToDoContentView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/5/24.
//

import UIKit

final class ToDoContentView: UIView & UIContentView {
  private let contentView: Styled.Row
  
  var configuration: any UIContentConfiguration
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(configuration: ToDoContentViewContentConfiguration) {
    self.configuration = configuration
    self.contentView = Styled.Row(
      configuration: Styled.Row.Configuration.todoList(configuration.model)
    )
    super.init(frame: CGRect.zero)
    self.setup()
  }
}

extension ToDoContentView {
  private func setup() {
    self.setupContentViewLayout()
  }
  
  private func setupContentViewLayout() {
    self.backgroundColor = UIColor.white
    self.addSubview(self.contentView)
    self.contentView.equalToParent()
  }
}
