// swiftlint:disable file_length
import ToDoGardenUIComponent

import UIKit

struct GuideSceneBottomContentsViewBuilder {
  func buildSubviews(_ state: Guide.GuideState) -> [UIView] {
    switch state {
    case .todoCreate:
      return self.buildCreateToDo()
    case .groupManagement:
      return self.buildGroupManagement()
    case .todoEdit:
      return self.buildToDoEdit()
    case .shareTab:
      return self.buildShareTab()
    }
  }
}

// MARK: - Bottom Contents
extension GuideSceneBottomContentsViewBuilder {
  private func buildCreateToDo() -> [UIView] {
    return [
      self.buildCreateToDo1(),
      self.buildCreateToDo2(),
      self.buildCreateToDo3()
    ]
  }
  
  private func buildCreateToDo1() -> UIView {
    let buildLabel: (String) -> UILabel = {
      UILabel.bodySemibold(text: $0, textColor: UIColor.toDoGardenGreenDark)
    }
    
    return UIStackView(
      arrangedSubviews: [
        buildLabel("그룹 우측"),
        UIStackView(
          arrangedSubviews: [
            buildCreateToDo1Button(),
            buildLabel(" 을 눌러서")
          ]
        ),
        buildLabel("투두를 생성할 수 있어요.")
      ],
      spacing: 6
    )
  }
  
  private func buildCreateToDo1Button() -> UIButton {
    let button = UIButton(configuration: UIButton.Configuration.borderedTinted())
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
    button.configuration?.baseForegroundColor = UIColor.toDoGardenGreenDark
    button.configuration?.baseBackgroundColor = UIColor.clear
    button.backgroundColor = UIColor.toDoGardenGreenBackground
    button.layer.cornerRadius = 4
    button.isUserInteractionEnabled = false
    
    return button
  }
  
  private func buildCreateToDo2() -> UIView {
    UIStackView(
      arrangedSubviews: [
        UILabel.bodySemibold(text: "생성한 투두를 끝마쳤다면,"),
        UILabel.headSemibold(text: "투두를 눌러서 완료할 수 있어요!")
          .addBottomLine(width: 91, height: 2)
      ],
      spacing: 8
    )
  }
  
  private func buildCreateToDo3() -> UIView {
    let imageView = UIImageView(image: UIImage.timerButtonImage)
    let label = UILabel.bodySemibold(
      text: "버튼을 눌러서",
      textColor: UIColor.toDoGardenGreenDark
    )
    let hstack = UIStackView(arrangedSubviews: [imageView, label])
    imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
    return UIStackView(
      arrangedSubviews: [
        hstack,
        UILabel.headSemibold(text: "타이머를 실행할 수 있어요.")
          .addPadding(.leading, value: 3)
      ],
      spacing: 8
    )
  }
}

// MARK: - Group Management
extension GuideSceneBottomContentsViewBuilder {
  private func buildGroupManagement() -> [UIView] {
    [
      self.buildGroupManagement1(),
      self.buildGroupManagement2(),
      self.buildGroupManagement3()
    ]
  }
  
  private func buildGroupManagement1() -> UIView {
    UIStackView(
      arrangedSubviews: [
        UILabel.bodySemibold(text: "원하는 그룹을 터치하면"),
        UILabel.headSemibold(text: "그룹 수정 화면에 들어갈 수 있어요.")
      ],
      spacing: 8
    )
  }
  
  private func buildGroupManagement2() -> UIView {
    UIStackView(
      arrangedSubviews: [
        buildGroupManagement2HStack(),
        UILabel.headSemibold(text: "그룹을 생성할 수 있어요.")
          .addPadding(.leading, value: 10)
      ],
      spacing: 8
    )
  }
  
  private func buildGroupManagement2HStack() -> UIStackView {
    let image = UIImage.createToDoButtonImage
      .resizing(targetSize: CGSize(width: 9, height: 9))
    let imageView = UIImageView(image: image)
    imageView.contentMode = UIView.ContentMode.center
    
    let hstack = UIStackView(
      .horizontal,
      arrangedSubviews: [
        imageView,
        UILabel.bodySemibold(
          text: "그룹 추가하기",
          textColor: UIColor.toDoGardenGreenDark
        )
        .addBottomLine(),
        UILabel.bodySemibold(text: "버튼을 터치하면")
      ],
      spacing: 3
    )
    hstack.alignment = .top
    imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    return hstack
  }
  
  private func buildGroupManagement3() -> UIView {
    let label = UILabel()
    label.font = UIFont.pretendardBodySemiBold
    let text = "편집 버튼을 누르면"
    let attributedString = NSMutableAttributedString(string: text)
    label.textColor = .systemGray3
    let range = (text as NSString).range(of: "편집")
    attributedString.addAttribute(
      NSAttributedString.Key.foregroundColor,
      value: UIColor.toDoGardenOrange,
      range: range
    )
    label.attributedText = attributedString
    
    return UIStackView(
      arrangedSubviews: [
        label,
        UILabel.headSemibold(text: "그룹 삭제와 수정을 할 수 있어요.")
      ],
      spacing: 8
    )
  }
}

// MARK: - ToDo Edit
extension GuideSceneBottomContentsViewBuilder {
  private func buildToDoEdit() -> [UIView] {
    return [
      self.buildToDoEdit1(),
      self.buildToDoEdit2(),
      self.buildToDoEdit3()
    ]
  }
  
  private func buildToDoEdit1() -> UIView {
    UIStackView(
      arrangedSubviews: [
        UILabel.bodySemibold(text: "오른쪽 스와이프를 통해서"),
        UILabel.headSemibold(text: "투두 수정화면에 들어갈 수 있어요.")
          .addBottomLine(width: 91),
        UILabel.headSemibold(text: "투두 삭제도 가능해요!")
          .addBottomLine(width: 60)
      ],
      spacing: 8
    )
  }
  
  private func buildToDoEdit2() -> UIView {
    UIStackView(
      arrangedSubviews: [
        UILabel.bodySemibold(text: "편집 탭에서"),
        UILabel.headSemibold(text: "투두의 이름과 그룹을"),
        UILabel.headSemibold(text: "변경할 수 있어요.")
      ],
      spacing: 7
    )
  }
  
  private func buildToDoEdit3() -> UIView {
    UIStackView(
      arrangedSubviews: [
        UILabel.bodySemibold(text: "알림 탭에서"),
        UILabel.headSemibold(text: "알림 시간을 설정할 수 있어요.")
      ],
      spacing: 5
    )
  }
}

// MARK: - Share Tab
extension GuideSceneBottomContentsViewBuilder {
  private func buildShareTab() -> [UIView] {
    return [
      self.buildShareTab1(),
      self.buildShareTab2()
    ]
  }
  
  private func buildShareTab1() -> UIView {
    UIStackView(
      arrangedSubviews: [
        UILabel.bodySemibold(text: "공유화면 프로필에서"),
        buildShareTab2HStack(),
        UILabel.headSemibold(text: "통계화면으로 이동해요.")
      ],
      spacing: 7
    )
  }
  
  private func buildShareTab2HStack() -> UIStackView {
    let imageView = UIImageView(image: UIImage.forwardButtonImage)
    let stack = UIStackView(
      .horizontal,
      arrangedSubviews: [
        UILabel.bodySemibold(text: "더보기"),
        imageView,
        UILabel.headSemibold(text: "버튼을 터치하면")
      ],
      alignment: .center,
      spacing: -4
    )
    imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
    return stack
  }
  
  private func buildShareTab2() -> UIView {
    let hstack = buildShareTab2HStack2()
    let label = UILabel.headSemibold(text: "열심히 쌓아온 기록을")
    let label2 = UILabel.headSemibold(text: "인스타그램 스토리를 통해\n공유할 수 있어요.")
    label2.numberOfLines = 2
    
    return UIStackView(
      arrangedSubviews: [hstack, label, label2],
      spacing: 7
    )
  }
  
  private func buildShareTab2HStack2() -> UIStackView {
    UIStackView(
      .horizontal,
      arrangedSubviews: [
        UILabel.bodySemibold(text: "우측 상단 공유"),
        UIImageView(image: UIImage.shareIconImage),
        UILabel.bodySemibold(text: "버튼을 통해")
      ],
      alignment: .center,
      spacing: 1
    )
  }
}

// MARK: - View Utils
private extension UIView {
  func addBottomLine(width: CGFloat? = nil, height: CGFloat = 1) -> UIView {
    let line = UIView()
    line.backgroundColor = UIColor.toDoGardenGreenDark
    
    let stack = UIStackView(arrangedSubviews: [self, line])
    stack.axis = .vertical
    stack.alignment = .leading
    
    if let width {
      line.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor).isActive = true
      line.widthAnchor.constraint(equalToConstant: width).isActive = true
    } else {
      line.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    line.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    return stack
  }
  
  func addPadding(_ edge: NSLayoutConstraint.Attribute, value: CGFloat) -> UIView {
    let spacing = UIView()
    let subviews: [UIView]
    switch edge {
    case .leading, .top:
      subviews = [spacing, self]
    case .trailing, .bottom:
      subviews = [self, spacing]
    default:
      subviews = []
    }
    let stack = UIStackView(arrangedSubviews: subviews)
    if edge.isVertical {
      stack.axis = .vertical
    }
    spacing.widthAnchor.constraint(equalToConstant: value).isActive = true
    
    return stack
  }
}

private extension NSLayoutConstraint.Attribute {
  var isVertical: Bool {
    switch self {
    case .top, .bottom:
      return true
    default:
      return false
    }
  }
}

private extension UIStackView {
  convenience init(
    _ axis: NSLayoutConstraint.Axis = .vertical,
    arrangedSubviews: [UIView],
    alignment: Alignment = .leading,
    spacing: CGFloat
  ) {
    self.init(arrangedSubviews: arrangedSubviews)
    self.axis = axis
    self.spacing = spacing
    self.alignment = alignment
  }
}

private extension UILabel {
  convenience init(
    text: String,
    font: UIFont,
    textColor: UIColor
  ) {
    self.init(frame: .zero)
    self.text = text
    self.font = font
    self.textColor = textColor
  }
  
  static func bodySemibold(
    text: String,
    textColor: UIColor = UIColor.toDoGardenGray3
  ) -> UILabel {
    UILabel(
      text: text,
      font: UIFont.pretendardBodySemiBold,
      textColor: textColor
    )
  }
  
  static func headSemibold(
    text: String,
    textColor: UIColor = UIColor.toDoGardenGreenDark
  ) -> UILabel {
    UILabel(
      text: text,
      font: UIFont.pretendardHeadSemiBold,
      textColor: textColor
    )
  }
}

private extension UIImage {
  func resizing(targetSize size: CGSize) -> UIImage? {
    UIGraphicsImageRenderer(size: size).image { _ in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
// swiftlint:enable file_length
