import UIKit

final class StrikethroughView: UIView {
  let label: UILabel
  let strikethroughLayer: StrikethroughLayer
  
  override var intrinsicContentSize: CGSize {
    let subViewSize = label.intrinsicContentSize
    return CGSize(
      width: subViewSize.width + 10,
      height: subViewSize.height
    )
  }
  
  init(label: UILabel, foregroundColor: UIColor) {
    self.label = label
    self.strikethroughLayer = StrikethroughLayer(
      color: foregroundColor,
      lineWidth: 1
    )
    super.init(frame: .zero)
    self.prepareView(foregroundColor)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.strikethroughLayer.frame = self.bounds
  }
  
  func update(_ text: String?) {
    self.label.text = text
    self.invalidateIntrinsicContentSize()
    self.strikethroughLayer.animate()
  }
  
  private func prepareView(_ color: UIColor) {
    self.label.textColor = color
    self.setupLabelConstraints()
    self.layer.addSublayer(self.strikethroughLayer)
  }
  
  private func setupLabelConstraints() {
    self.label.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.label)
    NSLayoutConstraint.activate([
      self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}
