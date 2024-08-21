
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
        return bottomBuilder.buildGroupManagement()
      case .todoEdit:
        return bottomBuilder.buildToDoEdit()
      case .shareTab:
        return bottomBuilder.buildShareTab()
      }
    }
  )
}

extension GuideSceneBottomContentsViewBuilder {
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
  
  private func buildLabel(
    text: String,
    font: UIFont = UIFont.pretendardBodySemiBold,
    textColor: UIColor = UIColor.toDoGardenGreenDark
  ) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    label.setContentHuggingPriority(
      .defaultHigh,
      for: .horizontal
    )
    
    return label
  }
  
  private func addBottomLine(_ view: UIView, width: CGFloat) -> UIView {
    let line = UIView()
    line.backgroundColor = UIColor.toDoGardenGreenDark
    let stack = UIStackView(arrangedSubviews: [view, line])
    stack.axis = .vertical
    stack.alignment = .leading
    
    line.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
    line.widthAnchor.constraint(equalToConstant: width).isActive = true
    
    
    line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    return stack
  }
}

// MARK: - Bottom Contents
struct GuideSceneBottomContentsViewBuilder {
  func buildCreateToDo() -> [UIView] {
    return [buildCreateToDo1(), buildCreateToDo2(), buildCreateToDo3()]
  }
  
  private func buildCreateToDo1() -> UIView {
    let label = buildLabel(text: "그룹 우측")
    let label2 = buildLabel(text: " 을 눌러서")
    let hstack = UIStackView(arrangedSubviews: [buildCreateToDo1Button(), label2])
    let label3 = buildLabel(text: "투두를 생성할 수 있어요.")
    
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
    let label = buildLabel(text: "생성한 투두를 끝마쳤다면,")
    
    let label2 = buildLabel(
      text: "투두를 눌러서 완료할 수 있어요!",
      font: UIFont.pretendardHeadSemiBold
    )
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
    let label = buildLabel(text: "버튼을 눌러서")
    let hstack = UIStackView(arrangedSubviews: [imageView, label])
    
    let label2 = buildLabel(
      text: "타이머를 실행할 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
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
}

// MARK: - Group Management
extension GuideSceneBottomContentsViewBuilder {
  func buildGroupManagement() -> [UIView] {
    [buildGroupManagement1(), buildGroupManagement2(), buildGroupManagement3()]
  }
  
  private func buildGroupManagement1() -> UIView {
    let label = buildLabel(
      text: "원하는 그룹을 터치하면",
      textColor: UIColor.toDoGardenGray3
    )
    let label2 = buildLabel(
      text: "그룹 수정 화면에 들어갈 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
    
    return wrapping(buildStack(subviews: [label, label2], spacing: 8))
  }
  
  private func buildGroupManagement2() -> UIView {
    let image = UIImage.createToDoButtonImage
      .resizing(targetSize: CGSize(width: 9, height: 9))
    let imageView = UIImageView(image: image)
    imageView.contentMode = UIView.ContentMode.center
    
    let label = buildLabel(text: "그룹 추가하기", font: UIFont.pretendardBodySemiBold13)
    let line = UIView()
    line.backgroundColor = UIColor.toDoGardenGreenDark
    let spacing = UIView()
    let stack = UIStackView(arrangedSubviews: [label, line, spacing])
    stack.axis = .vertical
    stack.spacing = 1
    line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    spacing.heightAnchor.constraint(equalToConstant: 1).isActive = true
    stack.setCustomSpacing(0, after: line)
    
    let label2 = buildLabel(text: "버튼을 터치하면", textColor: UIColor.toDoGardenGray3)
    let hstack = UIStackView(arrangedSubviews: [imageView, stack, label2])
    hstack.alignment = .top
    hstack.spacing = 3
    imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    let label3 = buildLabel(
      text: "그룹을 생성할 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
    let spacing2 = UIView()
    let hstack2 = UIStackView(arrangedSubviews: [spacing2, label3])
    spacing2.widthAnchor.constraint(equalToConstant: 10).isActive = true
    
    
    return wrapping(buildStack(subviews: [hstack, hstack2], spacing: 8))
  }
  
  private func buildGroupManagement3() -> UIView {
    let label = UILabel()
    let fullText = "편집 버튼을 누르면"
    let attributedString = NSMutableAttributedString(string: fullText)
    label.textColor = .systemGray3
    let range = (fullText as NSString).range(of: "편집")
    attributedString.addAttribute(.foregroundColor, value: UIColor.toDoGardenOrange, range: range)
    
    label.attributedText = attributedString
    label.font = UIFont.pretendardBodySemiBold
    let label2 = buildLabel(
      text: "그룹 삭제와 수정을 할 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
    
    return wrapping(buildStack(subviews: [label, label2], spacing: 8))
  }
}


extension UIImage {
  func resizing(targetSize size: CGSize) -> UIImage? {
    UIGraphicsImageRenderer(size: size).image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}

// MARK: - ToDo Edit
extension GuideSceneBottomContentsViewBuilder {
  func buildToDoEdit() -> [UIView] {
    return [buildToDoEdit1(), buildToDoEdit2(), buildToDoEdit3()]
  }
  
  private func buildToDoEdit1() -> UIView {
    let label = buildLabel(text: "오른쪽 스와이프를 통해서", textColor: UIColor.toDoGardenGray3)
    let label2 = addBottomLine(
      buildLabel(
        text: "투두 수정화면에 들어갈 수 있어요.",
        font: UIFont.pretendardHeadSemiBold
      ),
      width: 91
    )
    let label3 = addBottomLine(
      buildLabel(
        text: "투두 삭제도 가능해요!",
        font: UIFont.pretendardHeadSemiBold
      ),
      width: 60
    )
    
    return wrapping(buildStack(subviews: [label, label2, label3], spacing: 8))
  }
  
  private func buildToDoEdit2() -> UIView {
    let label = buildLabel(
      text: "편집 탭에서",
      textColor: UIColor.toDoGardenGray3
    )
    let label2 = buildLabel(
      text: "투두의 이름과 그룹을",
      font: UIFont.pretendardHeadSemiBold
    )
    let label3 = buildLabel(
      text: "변경할 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
    
    return wrapping(
      buildStack(
        subviews: [label, label2, label3],
        spacing: 7
      )
    )
  }
  
  private func buildToDoEdit3() -> UIView {
    let label = buildLabel(
      text: "알림 탭에서",
      textColor: UIColor.toDoGardenGray3
    )
    let label2 = buildLabel(
      text: "알림 시간을 설정할 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
    
    return wrapping(
      buildStack(
        subviews: [label, label2],
        spacing: 5
      )
    )
  }
}

// MARK: - Share Tab
extension GuideSceneBottomContentsViewBuilder {
  func buildShareTab() -> [UIView] {
    return [buildShareTab1(), buildShareTab2()]
  }
  
  private func buildShareTab1() -> UIView {
    let label = buildLabel(
      text: "공유화면 프로필에서",
      textColor: UIColor.toDoGardenGray3
    )
    
    let label2 = buildLabel(
      text: "더보기",
      textColor: UIColor.toDoGardenGray3
    )
    let imageView = UIImageView(image: UIImage.forwardButtonImage)
    let label3 = buildLabel(text: "버튼을 터치하면", font: UIFont.pretendardHeadSemiBold)
    let hstack = UIStackView(arrangedSubviews: [label2, imageView, label3])
    imageView.usingAutolayout()
    imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    hstack.spacing = -4
    let label4 = buildLabel(text: "통계화면으로 이동해요.", font: UIFont.pretendardHeadSemiBold)
    return wrapping(
      buildStack(
        subviews: [label, hstack, label4],
        spacing: 7
      )
    )
  }

  private func buildShareTab2() -> UIView {
    let label = buildLabel(
      text: "우측 상단 공유",
      textColor: UIColor.toDoGardenGray3
    )
    let imageView = UIImageView(image: UIImage.shareIconImage)
    let label2 = buildLabel(
      text: "버튼을 통해",
      textColor: UIColor.toDoGardenGray3
    )
    let hstack = UIStackView(arrangedSubviews: [label, imageView, label2])
    hstack.spacing = 1
    
    let label3 = buildLabel(
      text: "열심히 쌓아온 기록을",
      font: UIFont.pretendardHeadSemiBold
    )
    let label4 = buildLabel(
      text: "인스타그램 스토리를 통해\n공유할 수 있어요.",
      font: UIFont.pretendardHeadSemiBold
    )
    label4.numberOfLines = 2
    
    
    return wrapping(
      buildStack(
        subviews: [hstack, label3, label4],
        spacing: 7
      )
    )
  }
}
