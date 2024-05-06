import Combine
import UIKit

import ToDoGardenUIConstant

// MARK: - ProfileStyle
extension Styled.Row {
  func buildProfileStyle(stack: UIStackView, model: Configuration.ProfileModel) {
    self.buildProfileStyleStack(stack: stack)
    let imageView = self.buildImageView(
      stack: stack,
      image: model.image,
      size: Constant.Styled.Row.Profile.profileSize
    )
    self.buildInnerStack(stack: stack, model: model)
    if model.axis == NSLayoutConstraint.Axis.vertical {
      stack.addSpacing()
    }
    self.buildImageView(
      stack: stack,
      image: UIImage.forwardButtonImage,
      size: Constant.Styled.Row.Profile.accessorySize
    )
    self.bindingProfileImageState(imageView: imageView)
  }
  
  private func buildProfileStyleStack(stack: UIStackView) {
    stack.isLayoutMarginsRelativeArrangement = true
    stack.spacing = Constant.Styled.Row.Profile.stackSpacing
    self.buildStack(
      stack: stack,
      edgeInsets: Constant.Styled.Row.Profile.stackEdgeInsets
    )
  }
  
  private func buildInnerStack(stack: UIStackView, model: Configuration.ProfileModel) {
    let innerStack = UIStackView()
    innerStack.axis = model.axis
    let titleLabel = self.buildTextLabel(
      stack: innerStack,
      text: model.title,
      font: model.titleFont,
      textColor: .toDoGardenGreenDark
    )
    addConditionalSpacing(innerStack, axis: model.axis)
    let descriptionLabel = self.buildTextLabel(
      stack: innerStack,
      text: model.description,
      font: model.descriptionFont,
      textColor: .toDoGardenGreenDark
    )
    stack.addArrangedSubview(innerStack)
    bindingProfileInnerTitleState(
      titleLabel: titleLabel,
      descriptionLabel: descriptionLabel
    )
  }
  
  private func addConditionalSpacing(_ stack: UIStackView, axis: NSLayoutConstraint.Axis) {
    switch axis {
    case NSLayoutConstraint.Axis.vertical:
      stack.spacing = Constant.Styled.Row.Profile.conditionSpacing
    case NSLayoutConstraint.Axis.horizontal:
      stack.addSpacing()
    @unknown default:
      break
    }
  }
  
  private func bindingProfileImageState(imageView: UIImageView) {
    self.$configutration
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
    self.$configutration
      .map(\.profileModel?.description)
      .removeDuplicates()
      .sink { [weak descriptionLabel] text in
        descriptionLabel?.text = text
      }
      .store(in: &cancellables)
    self.$configutration
      .map(\.profileModel?.title)
      .removeDuplicates()
      .sink { [weak titleLabel] text in
        titleLabel?.text = text
      }
      .store(in: &cancellables)
  }
}
