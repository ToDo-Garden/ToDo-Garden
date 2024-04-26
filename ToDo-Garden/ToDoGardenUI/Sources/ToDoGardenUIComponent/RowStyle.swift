import Combine
import UIKit

extension Styled {
  open class Row: UIView {
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
          self.configutration = .profile(model)
        }
      }
    }
    
    @Published private var configutration: Configuration
    private var cancellables: Set<AnyCancellable> = []
    
    public init(configuration: Configuration) {
      self.configutration = configuration
      super.init(frame: CGRect.zero)
      self.build()
    }
    
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
      self.cancellables.removeAll()
    }
    
    private func build() {
      let stack = UIStackView(frame: CGRect.zero)
      switch self.configutration {
      case let .profile(profileModel):
        self.buildProfileStyle(stack: stack, model: profileModel)
        
      case let .listPrimary(listPrimaryModel):
        self.buildListPrimaryStyle(stack: stack, model: listPrimaryModel)
      }
    }
  }
}

extension Styled.Row {
  public enum Configuration {
    var profileModel: ProfileModel? {
      if case let .profile(model) = self {
        return model
      }
      return nil
    }
    
    var listPrimaryModel: ListPrimaryModel? {
      if case let .listPrimary(model) = self {
        return model
      }
      return nil
    }
    
    case profile(ProfileModel)
    case listPrimary(ListPrimaryModel)
  }
}

extension Styled.Row.Configuration {
  public struct ProfileModel {
    var image: UIImage = .defaultFriendProfileImage
    var title: String
    var description: String
  }
  
  public struct ListPrimaryModel {
    let title: String
    let color: UIColor
  }
}

// MARK: - Shared View Logic
extension Styled.Row {
  private func buildStack(stack: UIStackView, edgeInsets: NSDirectionalEdgeInsets) {
    stack.alignment = .center
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
  private func buildImageView(stack: UIStackView, image: UIImage, size: CGSize) -> UIImageView {
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
  private func buildTextLabel(stack: UIStackView, text: String, font: UIFont, textColor: UIColor) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    stack.addArrangedSubview(label)
    return label
  }
  
  private func buildSpacing(stack: UIStackView) {
    let spacing = UIView()
    stack.addArrangedSubview(spacing)
  }
}

// MARK: - ProfileStyle
extension Styled.Row {
  private func buildProfileStyle(stack: UIStackView, model: Configuration.ProfileModel) {
    self.buildProfileStyleStack(stack: stack)
    let imageView = self.buildImageView(
      stack: stack,
      image: model.image,
      size: CGSize(width: 55, height: 55)
    )
    self.$configutration
      .map(\.profileModel?.image)
      .removeDuplicates()
      .sink { [weak imageView] image in
        imageView?.image = image
      }
      .store(in: &cancellables)
    self.buildVStack(stack: stack, model: model)
    self.buildSpacing(stack: stack)
    self.buildImageView(
      stack: stack,
      image: .buttonForward,
      size: CGSize(width: 24, height: 24)
    )
  }
  
  private func buildProfileStyleStack(stack: UIStackView) {
    stack.axis = .horizontal
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
  
  private func buildVStack(stack: UIStackView, model: Configuration.ProfileModel) {
    let vStack = UIStackView(frame: CGRect.zero)
    vStack.axis = .vertical
    vStack.spacing = 3
    let titleLabel = self.buildTextLabel(
      stack: vStack, text: model.title, font: .pretendardHeadBold, textColor: .toDoGardenGreenDark
    )
    self.$configutration
      .map(\.profileModel?.title)
      .removeDuplicates()
      .sink { [weak titleLabel]text in
        titleLabel?.text = text
      }
      .store(in: &cancellables)
    let descriptionLabel = self.buildTextLabel(
      stack: vStack, text: model.description, font: .pretendardDetailLight, textColor: .toDoGardenGreenDark
    )
    self.$configutration
      .map(\.profileModel?.description)
      .removeDuplicates()
      .sink { [weak descriptionLabel] text in
        descriptionLabel?.text = text
      }
      .store(in: &cancellables)
    stack.addArrangedSubview(vStack)
  }
}

// MARK: - ListPrimary
extension Styled.Row {
  private func buildListPrimaryStyle(stack: UIStackView, model: Configuration.ListPrimaryModel) {
    stack.alignment = .center
    self.buildStack(
      stack: stack,
      edgeInsets: NSDirectionalEdgeInsets(
        top: 0,
        leading: 14,
        bottom: 0,
        trailing: 14
      )
    )
    // MARK: - TODO: 레이블 집어넣기
    
    self.buildSpacing(stack: stack)
    self.buildColorView(stack: stack, color: model.color)
  }
  
  private func buildColorView(stack: UIStackView, color: UIColor) {
    let colorView = UIView()
    colorView.backgroundColor = color
    colorView.layer.cornerRadius = 12
    colorView.usingAutolayout()
    NSLayoutConstraint.activate([
      colorView.widthAnchor.constraint(equalToConstant: 24),
      colorView.heightAnchor.constraint(equalToConstant: 24)
    ])
    stack.addArrangedSubview(colorView)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = Styled.Row(
    configuration: .listPrimary(.init(title: "영어독해", color: .red))
  )
  
  return view
}
#endif
