import UIKit

extension Styled.Row {
  func buildTodoListStyle(stack: UIStackView, model: Configuration.TodoListModel) {
    self.buildStack(
      stack: stack,
      edgeInsets: NSDirectionalEdgeInsets(top: 12, leading: 41, bottom: 12, trailing: 0)
    )
    let textField = self.buildTextField(stack: stack, text: model.text)
    self.buildButton(stack: stack, textField: textField)
    stack.addSpacing(8)
    stack.addArrangedSubview(textField)
    stack.addSpacing()
  }
  
  private func buildButton(stack: UIStackView, textField: UITextField) {
    let button = UIButton(
      configuration: .plain(),
      primaryAction: UIAction { [weak self, weak textField] action in
        guard
          let button = action.sender as? UIButton
        else { return }
        self?.updateTextField(textField, buttonSelected: button.isSelected)
        self?.configutration.todoListModel.map { model in
          var copy = model
          copy.isSelected = button.isSelected
          self?.configutration = .todoList(copy)
        }
      }
    )
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
      button.widthAnchor.constraint(equalToConstant: 18),
      button.heightAnchor.constraint(equalToConstant: 18)
    ])
    stack.addArrangedSubview(button)
  }
  
  private func buildTextField(stack: UIStackView, text: String?) -> UITextField {
    let textField = Styled.UITextField(configuration: .groupEdit(.todoList))
    textField.text = text
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
      textField.widthAnchor.constraint(equalToConstant: 200)
    ])
    
    return textField
  }
  
  private func updateTextField(_ textField: UITextField?, buttonSelected: Bool) {
    textField?.isEnabled = !buttonSelected
    textField?.textColor = buttonSelected ? UIColor.gray : UIColor.black
    if buttonSelected {
      let attributeString = NSMutableAttributedString(string: textField?.text ?? "")
      attributeString
        .addAttribute(
          NSAttributedString.Key.strikethroughStyle,
          value: 1,
          range: NSRange(location: 0, length: attributeString.length)
        )
      textField?.attributedText = attributeString
    } else {
      let temp = textField?.text
      textField?.attributedText = nil
      textField?.text = temp
    }
  }
}
