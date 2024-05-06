import UIKit

import ToDoGardenUIConstant

extension Styled.Row {
  func buildTodoListStyle(stack: UIStackView, model: Configuration.TodoListModel) {
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ToDoList.stackEdgeInsets
    )
    let (zStack, zStackHandler) = buildZStack(model: model)
    self.buildButton(stack: stack, isSelecetd: model.isSelected, handler: zStackHandler)
    stack.addSpacing(Constant.Styled.Row.ToDoList.stackSpacing)
    stack.addArrangedSubview(zStack)
    stack.addSpacing()
  }
  
  private func buildButton(stack: UIStackView, isSelecetd: Bool, handler: @escaping (Bool) -> Void) {
    let button = UIButton(
      configuration: .plain(),
      primaryAction: UIAction { [weak self] action in
        guard
          let button = action.sender as? UIButton
        else { return }
        handler(button.isSelected)
        self?.configutration.todoListModel.map { model in
          var copy = model
          copy.isSelected = button.isSelected
          self?.configutration = .todoList(copy)
        }
      }
    )
    button.isSelected = isSelecetd
    buildButtonConfiguration(button)
    builButtonLayout(button, stack: stack)
  }
  
  private func buildButtonConfiguration(_ button: UIButton) {
    button.configuration?.baseForegroundColor = UIColor.toDoGardenRed
    button.configurationUpdateHandler = { button in
      switch button.state {
      case .selected, .highlighted:
        let image = UIImage(systemName: "checkmark.square.fill")
        button.configuration?.image = image
      default:
        button.configuration?.image = UIImage(systemName: "square")
      }
    }
    button.changesSelectionAsPrimaryAction = true
  }
  
  private func builButtonLayout(_ button: UIButton, stack: UIStackView) {
    button.usingAutolayout()
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.buttonSize.width),
      button.heightAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.buttonSize.height)
    ])
    stack.addArrangedSubview(button)
  }
  
  private func buildTextField(text: String?, isSelected: Bool) -> UITextField {
    let textField = Styled.TextField(configuration: .groupEdit(.todoList))
    textField.text = text
    textField.font = UIFont.pretendardDetailLight
    textField.textColor = UIColor.toDoGardenGreenDark
    textField.isHidden = isSelected
    let action = UIAction { [weak self] action in
      if let textField = action.sender as? UITextField {
        self?.configutration.todoListModel
          .map { model in
            var copy = model
            copy.text = textField.text
            self?.configutration = .todoList(copy)
          }
      }
    }
    textField.addAction(action, for: .editingChanged)
    textField.usingAutolayout()
    NSLayoutConstraint.activate([
      textField.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.textFieldWidth)
    ])
    return textField
  }
  
  private func buildZStack(model: Configuration.TodoListModel) -> (UIView, (Bool) -> Void) {
    let textField = buildTextField(text: model.text, isSelected: model.isSelected)
    let zStack = UIStackView(arrangedSubviews: [textField])
    let (selectedView, selecetdViewUpdateAction) = buildSelectedView(
      zStack: zStack,
      model: model
    )
    zStack.addSubview(selectedView)
    
    selectedView.equalToParent()
    let action: (Bool) -> Void = { [weak textField, weak selectedView] isSelected in
      textField?.isHidden = isSelected
      selectedView?.isHidden = !isSelected
      if let text = textField?.text, isSelected {
        selecetdViewUpdateAction(text)
      } else {
        selecetdViewUpdateAction("")
      }
    }
    
    return (zStack, action)
  }
  
  private func buildSelectedView(
    zStack: UIStackView,
    model: Configuration.TodoListModel
  ) -> (UIView, (String) -> Void) {
    let stack = UIStackView()
    let label = buildSelecetdLabel(stack: zStack, text: model.text, isSelected: model.isSelected)
    let imageView = buildAlarmImage(stack: zStack, isSelected: model.isSelected, hasAlarm: model.hasAlert)
    zStack.addSubview(stack)
    stack.equalToParent()
    
    let action: (String) -> Void = { [weak self, weak label, weak imageView] text in
      self?.updateSelecetdView(
        label: label,
        imageView: imageView,
        text: text
      )
    }
    
    return (stack, action)
  }
  
  private func buildSelecetdLabel(stack: UIStackView, text: String?, isSelected: Bool) -> UILabel {
    let label = UILabel()
    label.textColor = UIColor.toDoGardenGray3
    label.font = UIFont.pretendardDetailLight
    stack.addArrangedSubview(label)
    if isSelected {
      label.attributedText = self.setAttributeText(text: text)
    }
    
    return label
  }
  
  private func buildAlarmImage(stack: UIStackView, isSelected: Bool, hasAlarm: Bool) -> UIImageView {
    let image = hasAlarm ? UIImage.alarmImage : nil
    let imageView = UIImageView(image: image)
    imageView.contentMode = UIView.ContentMode.scaleAspectFit
    imageView.isHidden = !isSelected
    stack.addArrangedSubview(imageView)
    
    return imageView
  }
  
  private func updateSelecetdView(label: UILabel?, imageView: UIImageView?, text: String) {
    label?.isHidden = text.isEmpty
    imageView?.isHidden = text.isEmpty
    label?.attributedText = text.isEmpty
    ? nil
    : self.setAttributeText(text: text)
  }
  
  private func setAttributeText(text: String?) -> NSMutableAttributedString {
    let attributeString = NSMutableAttributedString(string: text ?? "")
    attributeString
      .addAttribute(
        NSAttributedString.Key.strikethroughStyle,
        value: 1,
        range: NSRange(location: 0, length: attributeString.length)
      )
    
    return attributeString
  }
}
