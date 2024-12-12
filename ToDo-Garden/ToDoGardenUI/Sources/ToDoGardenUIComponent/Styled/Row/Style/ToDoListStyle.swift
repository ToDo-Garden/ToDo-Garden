import UIKit

import ToDoGardenUIConstant

extension Styled.Row {
  func buildTodoListStyle(stack: UIStackView, model: Configuration.TodoListModel) {
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ToDoList.stackEdgeInsets
    )
    let (zStack, zStackHandler) = self.buildZStack(model: model)
    let checkBox = self.buildCheckBox(zStackHandler)
    stack.addArrangedSubview(checkBox)
    self.setupCheckBoxConstraints(checkBox)
    
    stack.addSpacing(Constant.Styled.Row.ToDoList.stackSpacing)
    stack.addArrangedSubview(zStack)
    stack.addSpacing()
  }
  
  private func buildZStack(model: Configuration.TodoListModel) -> (UIView, (Bool) -> Void) {
    let textField = self.buildTextField(
      text: model.text,
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
  
  private func buildTextField(text: String?, isSelected: Bool) -> UITextField {
    let textField = Styled.TextField(configuration: .groupEdit(.todoList))
    textField.text = text
    textField.font = UIFont.pretendardDetailLight
    textField.textColor = UIColor.toDoGardenGreenDark
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
    label.textColor = UIColor.toDoGardenGray3
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
  
  private func buildCheckBox(_ handler: @escaping (Bool) -> Void) -> UIView {
    ToDoCheckBoxButton(
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
  Styled.Row(configuration: .todoList(.init(hasAlert: true)))
}
