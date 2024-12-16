import UIKit

import ToDoGardenUIConstant

// swiftlint:disable function_body_length
extension Styled.Row {
  func buildTodoListStyle(stack: UIStackView, model: Configuration.TodoListModel) {
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ToDoList.stackEdgeInsets
    )
    let (zStack, checkBoxAction) = self.buildZStack(model: model)
    let checkBox = self.buildCheckBox(color: model.foregroundColor, checkBoxAction)
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
    /// selectedView를 누르게 되면 selectedView를 숨기고 textField를 노출시킵니다.
    selectedView.addTapGesture { [weak selectedView, weak textField] in
      selectedView?.isHidden = true
      textField?.isHidden = false
      _ = textField?.becomeFirstResponder()
    }
    /// textField가 resign될 경우, textField의 텍스트 여부에 따라서 textField를 숨길지, selectedView를 보여줄지 결정하게 됩니다.
    textField.resignHandler = { [weak self, weak textField, weak selectedView] in
      let text = self?.configuration.todoListModel?.text
      textField?.text = self?.configuration.todoListModel?.text
      
      let textIsEmpty = text?.isEmpty ?? true
      textField?.isHidden = !textIsEmpty
      selectedView?.isHidden = textIsEmpty
      
      let isSelected = self?.configuration.todoListModel?.isSelected ?? true
      selecetdViewUpdateAction(text, isSelected)
    }
    
    return (
      zStack,
      { [weak textField, weak selectedView] isSelected in
        let flag = textField?.text?.isEmpty ?? true
        textField?.isHidden = flag ? isSelected : true
        selectedView?.isHidden = flag ? !isSelected : false
        selecetdViewUpdateAction(textField?.text, isSelected)
      }
    )
  }
  
  private func buildTextField(text: String?, color: UIColor, isSelected: Bool) -> Styled.TextField {
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
      let isSelected = self?.configuration.todoListModel?.isSelected ?? false
      let isEmpty = textField.text?.isEmpty ?? true
      if !isSelected || !isEmpty {
        self?.configuration.todoListModel?.text = textField.text
      }
    }
    textField.addAction(action, for: .editingChanged)
    
    return textField
  }
  
  private func setupTextFieldConstraints(_ textField: UIView) {
    textField.usingAutolayout()
    textField.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ToDoList.textFieldWidth).isActive = true
  }
  
  private func buildSelectedView(model: Configuration.TodoListModel) -> (UIView, (String?, Bool) -> Void) {
    let strikeThroughLabel = self.buildStrikethroughLabel(text: model.text)
    let imageView = self.buildAlarmImage(hasAlarm: model.hasAlert)
    let stack = UIHStackView(arrangedSubviews: [strikeThroughLabel, imageView])
    stack.isHidden = !model.isSelected
    
    return (
      stack,
      { [weak strikeThroughLabel] in
        strikeThroughLabel?.update(text: $0, animated: $1)
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
          let flag = (self?.configuration.todoListModel?.isSelected ?? true)
          if flag {
            handler(false)
          }
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
  let first = Styled.Row(configuration: .todoList(.init(foregroundColor: .orange, hasAlert: true)))
  let second = Styled.Row(configuration: .todoList(.init(foregroundColor: .toDoGardenGreenDark, hasAlert: false)))
  let third = Styled.Row(configuration: .todoList(.init(foregroundColor: .blue, hasAlert: false)))
  let stack = UIVStackView(arrangedSubviews: [first, second, third])
  first.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  second.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  third.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  return stack
}
// swiftlint:enable function_body_length
