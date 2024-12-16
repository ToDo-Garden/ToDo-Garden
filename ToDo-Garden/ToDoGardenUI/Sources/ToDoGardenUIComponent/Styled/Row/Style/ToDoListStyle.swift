import UIKit

import ToDoGardenUIConstant

extension Styled.Row {
  func buildTodoListStyle(stack: UIStackView, model: Configuration.TodoListModel) {
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ToDoList.stackEdgeInsets
    )
    let (zStack, zStackHandler) = self.buildZStack(model: model)
    let checkBox = self.buildCheckBox(color: model.foregroundColor, zStackHandler)
    stack.addArrangedSubview(checkBox)
    self.setupCheckBoxConstraints(checkBox)
    
    stack.addSpacing(Constant.Styled.Row.ToDoList.stackSpacing)
    stack.addArrangedSubview(zStack)
    stack.addSpacing()
  }
  
  private func buildZStack(model: Configuration.TodoListModel) -> (UIView, (Bool) -> Void) {
    let textField = self.buildTextField(
      text: model.text,
      color: model.foregroundColor,
      isSelected: model.isSelected
    )
    self.setupTextFieldConstraints(textField)
    let zStack = UIStackView(arrangedSubviews: [textField])
    let (selectedView, selecetdViewUpdateAction) = buildSelectedView(model: model)
    zStack.addArrangedSubview(selectedView)
    
    return (
      zStack,
      { [weak textField, weak selectedView] isSelected in
        textField?.isHidden = isSelected
        selectedView?.isHidden = !isSelected
        if isSelected {
          selecetdViewUpdateAction(textField?.text)
        }
      }
    )
  }
  
  private func buildTextField(text: String?, color: UIColor, isSelected: Bool) -> UITextField {
    let textField = Styled.TextField(configuration: .groupEdit(.todoList(mainColor: color)))
    let placeholderText = " 할 일을 입력해주세요."
    textField.attributedPlaceholder = NSAttributedString(
      string: placeholderText,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenGray]
    )
    textField.text = text
    textField.font = UIFont.pretendardDetailRegular12
    textField.isHidden = isSelected
    let action = UIAction { [weak self] action in
      guard
        let textField = action.sender as? UITextField
      else { return }
      self?.configuration.todoListModel?.text = textField.text
    }
    textField.addAction(action, for: .editingChanged)
    
    return textField
  }
  
  private func setupTextFieldConstraints(_ textField: UIView) {
    textField.usingAutolayout()
    textField.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.textFieldWidth).isActive = true
  }
  
  private func buildSelectedView(model: Configuration.TodoListModel) -> (UIView, (String?) -> Void) {
    let strikeThroughLabel = self.buildStrikethroughLabel(text: model.text)
    let imageView = self.buildAlarmImage(hasAlarm: model.hasAlert)
    let stack = UIHStackView(arrangedSubviews: [strikeThroughLabel, imageView])
    stack.isHidden = !model.isSelected
    
    return (
      stack,
      { [weak strikeThroughLabel] in
        strikeThroughLabel?.update($0)
      }
    )
  }
  
  private func buildStrikethroughLabel(text: String?) -> StrikethroughView {
    let label = UILabel()
    label.text = text
    label.font = UIFont.pretendardDetailLight
    let strikethrough = StrikethroughView(
      label: label,
      foregroundColor: UIColor.toDoGardenGray3
    )
    
    return strikethrough
  }
  
  private func buildAlarmImage(hasAlarm: Bool) -> UIImageView {
    let image = hasAlarm ? UIImage.alarmImage : nil
    let imageView = UIImageView(image: image)
    imageView.contentMode = UIView.ContentMode.scaleAspectFit
    
    return imageView
  }
  
  private func buildCheckBox(color: UIColor, _ handler: @escaping (Bool) -> Void) -> UIView {
    let button = ToDoCheckBoxButton(
      action: UIAction { [weak self] action in
        guard
          let checkBox = action.sender as? ToDoCheckBoxButton
        else { return }
        if self?.configuration.todoListModel?.text?.isEmpty ?? true {
          checkBox.isActionBlocked = false
        } else {
          checkBox.isActionBlocked = true
          handler(checkBox.isSelected)
          self?.configuration.todoListModel?.isSelected = checkBox.isSelected
        }
      }
    )
    button.updateMainColor(color)
    
    return button
  }
  
  private func setupCheckBoxConstraints(_ checkBox: UIView) {
    NSLayoutConstraint.activate([
      checkBox.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.buttonSize.width),
      checkBox.heightAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.buttonSize.height)
    ])
  }
}

@available(iOS 17.0, *)
#Preview {
  Styled.Row(configuration: .todoList(.init(foregroundColor: .orange, hasAlert: true)))
}
