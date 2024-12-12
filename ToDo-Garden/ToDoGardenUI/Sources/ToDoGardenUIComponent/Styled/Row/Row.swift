import Combine
import UIKit

import ToDoGardenUIResource

extension Styled {
  final public class Row: UIView {
    public var iconImage: UIImage? {
      get {
        if let image = self.configuration.profileModel?.image {
          return image
        }
        return nil
      }
      set {
        if var model = self.configuration.profileModel, let newValue {
          model.image = newValue
          self.configuration = Configuration.profile(model)
        }
      }
    }

    public var groupListModel: Configuration.ListPrimaryModel? {
      get {
        if let groupListModel = self.configuration.listPrimaryModel {
          return groupListModel
        }
        return nil
      }
      set {
        if var model = self.configuration.listPrimaryModel, let newValue {
          model = newValue
          self.configuration = Configuration.listPrimary(model)
        }
      }
    }

    @Published public var configuration: Configuration
    @Published public var isSelected: Bool = false
    var cancellables: Set<AnyCancellable> = []
    
    private var stackView: UIStackView!
    
    public init(configuration: Configuration) {
      self.configuration = configuration
      super.init(frame: CGRect.zero)
      self.build()
    }
    
    public init(configuration: Configuration, with views: [UIView]) {
      self.configuration = configuration
      super.init(frame: CGRect.zero)
      self.build(with: views)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    public func resetState() {
      self.cancellables = []
      for subview in self.stackView.arrangedSubviews {
        subview.removeFromSuperview()
      }
      // TODO: 동적으로 높이가 변하는 뷰가 재사용이 될 경우, 해당 케이스도 고려하는 코드가 추가되야합니다.
    }
    
    private func build() {
      var stack = UIStackView(frame: CGRect.zero)
      switch self.configuration {
      case let Configuration.profile(profileModel):
        stack = self.buildProfileStyle(model: profileModel)
        self.layoutContainer(
          stack,
          innerPadding: profileModel[style: \.innerPadding]
        )
      case let Configuration.listPrimary(listPrimaryModel):
        self.buildListPrimaryStyle(stack: stack, model: listPrimaryModel)
      case let Configuration.todoList(todoListModel):
        self.buildTodoListStyle(stack: stack, model: todoListModel)
      case let Configuration.repeatOtherDays(repeatOtherDaysModel):
        self.buildRepeatOtherDaysStyle(stack: stack, model: repeatOtherDaysModel, views: nil)
      }
      self.stackView = stack
    }
    
    private func build(with views: [UIView]) {
      let stack = UIStackView(frame: CGRect.zero)
      switch self.configuration {
      case let Configuration.listPrimary(listPrimaryModel):
        self.buildListPrimaryStyle(stack: stack, model: listPrimaryModel, views: views)
      case let Configuration.repeatOtherDays(repeatOtherDaysModel):
        self.buildRepeatOtherDaysStyle(stack: stack, model: repeatOtherDaysModel, views: views)
      default: break
      }
      self.stackView = stack
    }
  }
}

// MARK: - Shared View Logic
// 앞으로의 방향
extension Styled.Row {
  func buildImageView(
    image: UIImage,
    size: CGSize
  ) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.usingAutolayout()
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: size.width),
      imageView.heightAnchor.constraint(equalToConstant: size.height)
    ])
    return imageView
  }
  
  func buildTextLabel(
    text: String,
    font: UIFont,
    textColor: UIColor
  ) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    return label
  }
  
  private func layoutContainer(
    _ stack: UIStackView,
    innerPadding: NSDirectionalEdgeInsets
  ) {
    stack.isLayoutMarginsRelativeArrangement = true
    stack.directionalLayoutMargins = innerPadding
    self.addSubview(stack)
    stack.equalToParent()
  }
}

extension Styled.Row {
  func buildStack(
    stack: UIStackView,
    axis: NSLayoutConstraint.Axis = NSLayoutConstraint.Axis.horizontal,
    edgeInsets: NSDirectionalEdgeInsets
  ) {
    stack.alignment = UIStackView.Alignment.center
    stack.axis = axis
    stack.isLayoutMarginsRelativeArrangement = true
    stack.directionalLayoutMargins = edgeInsets
    self.addSubview(stack)
    stack.usingAutolayout()
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: self.topAnchor),
      stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  @discardableResult
  func buildImageView(
    stack: UIStackView,
    image: UIImage,
    size: CGSize
  ) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.usingAutolayout()
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: size.width),
      imageView.heightAnchor.constraint(equalToConstant: size.height)
    ])
    stack.addArrangedSubview(imageView)
    return imageView
  }
  
  @discardableResult
  func buildTextLabel(
    stack: UIStackView,
    text: String,
    font: UIFont,
    textColor: UIColor
  ) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    stack.addArrangedSubview(label)
    return label
  }
}

@available(iOS 17.0, *)
#Preview {
  let row = Styled.Row(
    configuration: .profile(
      .init(
        style: .setting,
        title: "Setting",
        description: "안녕하세요"
      )
    )
  )
  row.backgroundColor = .systemIndigo
  
  let row2 = Styled.Row(
    configuration: .profile(
      .init(
        style: .shareProfile,
        title: "Share Profile",
        description: "안녕하세요"
      )
    )
  )
  row2.backgroundColor = .yellow
  
  let row3 = Styled.Row(
    configuration: .profile(
      .init(
        style: .shareRow,
        title: "Share Row",
        description: "15일째 연속 집중!"
      )
    )
  )
  row3.backgroundColor = .brown
  
  let row4 =  Styled.Row(
    configuration: .profile(
      .init(
        style: .myStats,
        title: "이인우님,\n15일 연속으로 기록 유지중이에요!",
        description: "9999.99.99 ~ 3333.33.33"
      )
    )
  )
  row4.backgroundColor = .lightGray
  
  let row5 = Styled.Row(
    configuration: .profile(
      .init(
        style: .searchRow,
        title: "SearchRow",
        description: "@userID"
      )
    )
  )
  row5.backgroundColor = .white
  
  let stack = UIVStackView(
    arrangedSubviews: [
      row, row2, row3, row4, row5
    ]
  )

  row.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  row2.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  row3.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  row4.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  row4.heightAnchor.constraint(equalToConstant: 110).isActive = true
  row5.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
  
  stack.alignment = .leading
  stack.backgroundColor = .green
  
  stack.translatesAutoresizingMaskIntoConstraints = false
  stack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
  
  return stack
}
