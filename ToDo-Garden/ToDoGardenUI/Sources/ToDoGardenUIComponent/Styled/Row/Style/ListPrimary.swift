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
}
