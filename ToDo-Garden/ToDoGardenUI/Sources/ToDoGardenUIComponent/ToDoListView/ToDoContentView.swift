//
//  ToDoContentView.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/5/24.
//

import UIKit

struct ToDoContentViewContentConfiguration: UIContentConfiguration {
  let model: ToDoListView.ToDoUIModel
  
  func makeContentView() -> any UIView & UIContentView {
    return ToDoContentView(configuration: self)
  }
  
  func updated(
    for state: any UIConfigurationState
  ) -> ToDoContentViewContentConfiguration {
    return self
  }
}

final class ToDoContentView: UIView & UIContentView {
  private var contentView: Styled.Row
  
  var configuration: any UIContentConfiguration {
    didSet {
      self.updateContentView()
    }
  }
  
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
  
  private func updateContentView() {
    guard let configuration = self.configuration as? ToDoContentViewContentConfiguration
    else { return }
    
    self.contentView.removeFromSuperview()
    self.contentView = Styled.Row(
      configuration: Styled.Row.Configuration.todoList(configuration.model)
    )
    self.setup()
  }
}
