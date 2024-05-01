import Combine
import UIKit

// MARK: - ProfileStyle
extension Styled.Row {
  func buildProfileStyle(stack: UIStackView, model: Configuration.ProfileModel) {
    self.buildProfileStyleStack(stack: stack)
    let imageView = self.buildImageView(
      stack: stack,
      image: model.image,
      size: CGSize(width: 55, height: 55)
    )
    self.buildInnerStack(stack: stack, model: model)
    if model.axis == NSLayoutConstraint.Axis.vertical {
      stack.addSpacing()
    }
    self.buildImageView(
      stack: stack,
      image: UIImage.forwardButtonImage,
      size: CGSize(width: 24, height: 24)
    )
    self.bindingProfileImageState(imageView: imageView)
  }
  
  private func buildProfileStyleStack(stack: UIStackView) {
    stack.isLayoutMarginsRelativeArrangement = true
    stack.spacing = 15
    self.buildStack(
      stack: stack,
      edgeInsets: NSDirectionalEdgeInsets(
        top: 8,
        leading: 16,
        bottom: 8,
        trailing: 36
      )
    )
  }
  
  private func buildInnerStack(stack: UIStackView, model: Configuration.ProfileModel) {
    let innerStack = UIStackView(frame: CGRect.zero)
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
      stack.spacing = 3
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
