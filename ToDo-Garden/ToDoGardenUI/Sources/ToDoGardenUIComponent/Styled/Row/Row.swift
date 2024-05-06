import Combine
import UIKit

import ToDoGardenUIResource

extension Styled {
  final public class Row: UIView {
    public var iconImage: UIImage? {
      get {
        if let image = self.configutration.profileModel?.image {
          return image
        }
        return nil
      }
      set {
        if var model = self.configutration.profileModel, let newValue {
          model.image = newValue
          self.configutration = Configuration.profile(model)
        }
      }
    }
    
    @Published var configutration: Configuration
    var cancellables: Set<AnyCancellable> = []
    
    public init(configuration: Configuration) {
      self.configutration = configuration
      super.init(frame: CGRect.zero)
      self.build()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func build() {
      let stack = UIStackView(frame: CGRect.zero)
      switch self.configutration {
      case let Configuration.profile(profileModel):
        self.buildProfileStyle(stack: stack, model: profileModel)
      case let Configuration.listPrimary(listPrimaryModel):
        self.buildListPrimaryStyle(stack: stack, model: listPrimaryModel)
      case let Configuration.todoList(todoListModel):
        self.buildTodoListStyle(stack: stack, model: todoListModel)
      }
    }
  }
}

// MARK: - Shared View Logic
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
    configuration: .listPrimary(.init(title: "영어독해", color: .red))
  )
  
  return row
}
