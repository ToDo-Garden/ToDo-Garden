
import ToDoGardenUIComponent

import UIKit

struct GuideSceneContentsBuilder: Sendable {
  var bottomContents: @Sendable (Guide.GuideState) -> [UIView]
}

extension GuideSceneContentsBuilder {
  static let live = GuideSceneContentsBuilder(
    bottomContents: { state in
      let bottomBuilder = GuideSceneBottomContentsViewBuilder()
      switch state {
      case .todoCreate:
        return bottomBuilder.buildCreateToDo()
      case .groupManagement:
        fatalError()
      case .todoEdit:
        fatalError()
      case .shareTab:
        fatalError()
      }
    }
  )
}

// MARK: - Bottom Contents
struct GuideSceneBottomContentsViewBuilder {
  func buildCreateToDo() -> [UIView] {
    return [buildCreateToDo1(), buildCreateToDo2(), buildCreateToDo3()]
  }
  
  private func buildCreateToDo1() -> UIView {
    let label = buildLabel()
    label.text = "그룹 우측"
    let label2 = buildLabel()
    label2.text = " 을 눌러서"
    let hstack = UIStackView(arrangedSubviews: [buildCreateToDo1Button(), label2])
    let label3 = buildLabel()
    label3.text = "투두를 생성할 수 있어요."
    
    return wrapping(
      buildStack(
        subviews: [label, hstack, label3],
        spacing: 6
      )
    )
  }
  
  private func buildCreateToDo1Button() -> UIButton {
    let button = UIButton(configuration: .borderedTinted())
    button.configuration?.title = "버튼"
    button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { value in
      var copy = value
      copy.font = UIFont.pretendardBodySemiBold
      copy.foregroundColor = UIColor.toDoGardenGreenDark
      return copy
    }
    let configuration = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
    let configuredImage = UIImage(systemName: "plus")?.withConfiguration(configuration)
    button.configuration?.image = configuredImage
    button.configuration?.imagePadding = 2
    button.configuration?.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
    button.configuration?.baseForegroundColor = .toDoGardenGreenDark
    button.configuration?.baseBackgroundColor = .clear
    button.backgroundColor = .toDoGardenGreenBackground
    button.layer.cornerRadius = 4
    return button
  }
  
  private func buildCreateToDo2() -> UIView {
    let label = buildLabel()
    label.text = "생성한 투두를 끝마쳤다면,"
    
    let label2 = buildLabel()
    label2.text = "투두를 눌러서 완료할 수 있어요!"
    let line = UIView()
    line.backgroundColor = .toDoGardenGreenDark
    
    let stack = UIStackView(
      arrangedSubviews: [label, label2, line]
    )
    stack.axis = .vertical
    stack.alignment = .leading
    stack.spacing = 8
    stack.setCustomSpacing(2, after: label2)
    
    line.widthAnchor.constraint(equalToConstant: 91).isActive = true
    line.heightAnchor.constraint(equalToConstant: 2).isActive = true
    
    return wrapping(stack)
  }
  
  private func buildCreateToDo3() -> UIView {
    let imageView = UIImageView(image: UIImage.timerButtonImage)
    let label = buildLabel()
    label.text = "버튼을 눌러서"
    let hstack = UIStackView(arrangedSubviews: [imageView, label])
    
    let label2 = buildLabel()
    label2.text = "타이머를 실행할 수 있어요."
    let padding = UIView()
    let hstack2 = UIStackView(arrangedSubviews: [padding, label2])
    padding.widthAnchor.constraint(equalToConstant: 3).isActive = true
    
    return wrapping(
      buildStack(
        subviews: [
          hstack, hstack2
        ],
        spacing: 8
      )
    )
  }
  
  private func buildStack(subviews: [UIView], spacing: CGFloat) -> UIView {
    let stack = UIStackView(
      arrangedSubviews: subviews
    )
    stack.axis = .vertical
    stack.alignment = .leading
    stack.spacing = spacing
    
    return stack
  }
  
  private func wrapping(_ view: UIView) -> UIView {
    
    let sp1 = UIView()
    let sp2 = UIView()
    
    let stack = UIStackView(arrangedSubviews: [sp1, view, sp2])
    stack.axis = .vertical
    stack.distribution = .equalSpacing
    sp1.heightAnchor.constraint(equalTo: sp2.heightAnchor).isActive = true
    stack.subviews.forEach {
      $0.isUserInteractionEnabled = false
    }
    
    return stack
  }
  
  private func buildLabel() -> UILabel {
    let label = UILabel()
    label.textColor = UIColor.toDoGardenGreenDark
    label.font = .pretendardBodySemiBold
    
    return label
  }
}

