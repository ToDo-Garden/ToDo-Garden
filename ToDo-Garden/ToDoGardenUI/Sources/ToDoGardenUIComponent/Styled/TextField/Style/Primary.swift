import UIKit
extension Styled.TextField {
  func buildPrimaryView(model: Configuration.PrimaryModel) {
    self.layer.cornerRadius = model.cornerRadius
    self.leftView = UIImageView(image: model.image)
    self.leftViewMode = ViewMode.always
  }
}
