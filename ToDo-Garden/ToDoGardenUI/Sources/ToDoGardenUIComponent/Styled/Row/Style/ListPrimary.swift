import UIKit

extension Styled.Row {
  func buildListPrimaryStyle(stack: UIStackView, model: Configuration.ListPrimaryModel) {
    stack.alignment = UIStackView.Alignment.center
    self.buildStack(
      stack: stack,
      edgeInsets: NSDirectionalEdgeInsets(
        top: 0,
        leading: 14,
        bottom: 0,
        trailing: 14
      )
    )
    // MARK: - TODO: 레이블 집어넣기
    
    stack.addSpacing()
    self.buildColorView(stack: stack, color: model.color)
  }
  
  private func buildColorView(stack: UIStackView, color: UIColor) {
    let colorView = UIView()
    colorView.backgroundColor = color
    colorView.layer.cornerRadius = 12
    colorView.usingAutolayout()
    NSLayoutConstraint.activate([
      colorView.widthAnchor.constraint(equalToConstant: 24),
      colorView.heightAnchor.constraint(equalToConstant: 24)
    ])
    stack.addArrangedSubview(colorView)
  }
}
