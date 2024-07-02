import UIKit

import ToDoGardenUIConstant

extension Styled.Row {
  func buildListPrimaryStyle(
    stack: UIStackView,
    model: Configuration.ListPrimaryModel,
    views: [UIView]? = nil
  ) {
    stack.alignment = UIStackView.Alignment.center
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ListPrimary.stackEdgeInsets
    )
    let label = GroupNameLabel(configuration: .primary(.defaultPrimaryModel))
    label.text = model.title
    stack.addArrangedSubview(label)
    stack.addSpacing()
    self.buildColorView(stack: stack, color: model.color)
    self.buildRightView(stack: stack, views: views)
    self.bindingGroupNameState(label: label)
  }
  
  private func buildColorView(stack: UIStackView, color: UIColor) {
    let colorView = UIView()
    colorView.backgroundColor = color
    colorView.layer.cornerRadius = Constant.Styled.Row.ListPrimary.colorViewCornerRadius
    colorView.usingAutolayout()
    NSLayoutConstraint.activate([
      colorView.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ListPrimary.colorViewSize.width),
      colorView.heightAnchor.constraint(equalToConstant: Constant.Styled.Row.ListPrimary.colorViewSize.height)
    ])
    stack.addArrangedSubview(colorView)
  }

  private func buildRightView(stack: UIStackView, views: [UIView]? = nil) {
    guard let rightView = views?.first
    else { return }

    rightView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        rightView.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ListPrimary.rightViewSize.width),
        rightView.widthAnchor.constraint(equalToConstant: Constant.Styled.Row.ListPrimary.rightViewSize.height)
      ]
    )
    stack.addArrangedSubview(rightView)
  }

  private func bindingGroupNameState(label: UILabel) {
    self.$configuration
      .map(\.listPrimaryModel?.title)
      .removeDuplicates()
      .sink { [weak label] title in
        label?.text = title
      }
      .store(in: &cancellables)
  }
}
