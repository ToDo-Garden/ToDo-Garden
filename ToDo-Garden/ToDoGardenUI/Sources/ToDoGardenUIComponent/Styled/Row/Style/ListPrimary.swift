import UIKit

import ToDoGardenUIConstant

extension Styled.Row {
  func buildListPrimaryStyle(stack: UIStackView, model: Configuration.ListPrimaryModel) {
    stack.alignment = UIStackView.Alignment.center
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.ListPrimary.stackEdgeInsets
    )
    // MARK: - TODO: 레이블 집어넣기
    
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
