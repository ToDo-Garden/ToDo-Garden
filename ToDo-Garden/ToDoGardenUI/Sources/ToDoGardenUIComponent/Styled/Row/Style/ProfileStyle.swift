import Combine
import UIKit

import ToDoGardenUIConstant

// MARK: - ProfileStyle
extension Styled.Row {
  func buildProfileStyle(model: Configuration.ProfileModel) -> UIStackView {
    let stack = UIHStackView(
      spacing: 0,
      arrangedSubviews: self.buildProfileSubviews(model: model)
    )
    stack.addInnerPadding(model[style: \.innerPadding])
    return stack
  }

  private func buildProfileSubviews(model: Configuration.ProfileModel) -> [UIView] {
    let profileImageView = self.buildImageView(
      image: model[style: \.defaultImage],
      size: model[style: \.imageSize]
    )
    self.bindingProfileImageState(imageView: profileImageView)
    let profileImageTrailingPadding = UIView()
    
    let innerStack = self.buildInnerStack(model: model)
    let forwardImage = UIImageView(image: UIImage.forwardButtonImage)
    if model.style == Configuration.ProfileModel.Style.shareRow {
      self.bindingForwardImage(imageView: forwardImage)
    }
    
    var subviews = [
      profileImageView,
      profileImageTrailingPadding,
      innerStack,
      forwardImage
    ]
    if model[style: \.axis] == .vertical {
      subviews.insert(UIView(), at: 3)
    }
    profileImageTrailingPadding.widthAnchor
      .constraint(equalToConstant: model[style: \.profileImageTrailingPadding]).isActive = true
    
    return subviews
  }
  
  private func buildInnerStack(model: Configuration.ProfileModel) -> UIStackView {
    let titleLabel = self.buildTextLabel(
      text: model.title,
      font: model[style: \.titleFont],
      textColor: UIColor.toDoGardenGreenDark
    )
    let descriptionLabel = self.buildTextLabel(
      text: model.description,
      font: model[style: \.descriptionFont],
      textColor: UIColor.toDoGardenGreenDark
    )
    self.bindingProfileInnerTitleState(
      titleLabel: titleLabel,
      descriptionLabel: descriptionLabel
    )
    
    let spacing = UIView()
    let subviews: [UIView] = [titleLabel, spacing, descriptionLabel]
    let stack = UIStackView(arrangedSubviews: subviews)
    stack.axis = model[style: \.axis]
    
    if model[style: \.axis] == NSLayoutConstraint.Axis.vertical {
      spacing.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    return stack
  }
  
  private func bindingProfileImageState(imageView: UIImageView) {
    self.$configuration
      .map(\.profileModel?.image)
      .removeDuplicates()
      .sink { [weak imageView] image in
        imageView?.image = image
      }
      .store(in: &cancellables)
  }
  
  private func bindingProfileInnerTitleState(
    titleLabel: UILabel,
    descriptionLabel: UILabel
  ) {
    self.$configuration
      .map(\.profileModel?.description)
      .removeDuplicates()
      .sink { [weak descriptionLabel] text in
        descriptionLabel?.text = text
      }
      .store(in: &cancellables)
    self.$configuration
      .map(\.profileModel?.title)
      .removeDuplicates()
      .sink { [weak titleLabel] text in
        titleLabel?.text = text
      }
      .store(in: &cancellables)
  }
  
  private func bindingForwardImage(imageView: UIImageView) {
    self.$isSelected
      .sink { [weak imageView] isSelected in
        let angle = isSelected ? CGFloat.pi / 2 : 0
        UIView.animate(withDuration: 0.2) {
          imageView?.transform = CGAffineTransform(rotationAngle: angle)
        }
      }
      .store(in: &cancellables)
  }
}
