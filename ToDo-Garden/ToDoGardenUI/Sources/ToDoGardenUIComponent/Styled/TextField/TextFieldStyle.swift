import Combine
import UIKit

public enum Styled { }

private typealias ViewMode = UIKit.UITextField.ViewMode

extension Styled {
  open class UITextField: UIKit.UITextField {
    public var mainColor: UIColor? {
      get {
        if case let .groupEdit(model) = self.configuration {
          return model.mainColor
        }
        return nil
      }
      set {
        if var model = self.configuration.groupEditModel, let newValue {
          model.mainColor = newValue
          self.configuration = .groupEdit(model)
        }
      }
    }
    
    @Published private var configuration: Configuration
    private var bottomLine: UIView!
    private var cancellables: Set<AnyCancellable> = []
    
    public init(configuration: Configuration) {
      self.configuration = configuration
      super.init(frame: CGRect.zero)
      self.build()
    }
    
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
      self.cancellables.removeAll()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.textRect(forBounds: bounds)
      return self.buildLeftImageMargin(rect)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.textRect(forBounds: bounds)
      return self.buildLeftImageMargin(rect)
    }
    
    private func buildLeftImageMargin(_ rect: CGRect) -> CGRect {
      let containedRect = self.configuration.primaryModel
        .map { model in
          var insets = UIEdgeInsets.zero
          insets.left = model.imageTrailingConstant
          return rect.inset(by: insets)
        }
      return containedRect ?? rect
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
      var rect = super.leftViewRect(forBounds: bounds)
      self.configuration.primaryModel
        .map { model in
          rect.origin.x = model.imageLeadingConstant
        }
      return rect
    }
    
    private func build() {
      self.clearButtonMode = ViewMode.whileEditing
      switch configuration {
      case let .primary(primaryModel):
        self.buildPrimaryView(model: primaryModel)
        
      case let .groupEdit(groupEditModel):
        self.buildClearButton(model: groupEditModel)
        self.buildBottomLine(color: groupEditModel.mainColor)
      }
    }
    
    private func buildPrimaryView(model: Configuration.PrimaryModel) {
      self.layer.cornerRadius = model.cornerRadius
      self.leftView = UIImageView(image: model.image)
      self.leftViewMode = ViewMode.always
    }
    
    private func buildClearButton(model: Configuration.GroupEditModel) {
      if let button = self.value(forKeyPath: "_clearButton") as? UIButton {
        button.setImage(model.image, for: .normal)
        button.tintColor = model.mainColor
        self.$configuration
          .compactMap(\.groupEditModel)
          .removeDuplicates()
          .sink { [weak button] model in
            button?.tintColor = model.mainColor
          }
          .store(in: &self.cancellables)
      }
    }
    
    private func buildBottomLine(color: UIColor) {
      let line = UIView()
      line.backgroundColor = color
      configuration.groupEditModel.map { model in
        switch model.bottomLineDisplayMode {
        case .always:
          line.isHidden = false
        case .editing, .none:
          line.isHidden = true
        }
      }
      line.usingAutolayout()
      self.addSubview(line)
      NSLayoutConstraint.activate([
        line.bottomAnchor.constraint(equalTo: bottomAnchor),
        line.leadingAnchor.constraint(equalTo: leadingAnchor),
        line.trailingAnchor.constraint(equalTo: trailingAnchor),
        line.heightAnchor.constraint(equalToConstant: 1)
      ])
      self.$configuration
        .compactMap(\.groupEditModel)
        .removeDuplicates()
        .sink { [weak line] model in
          line?.backgroundColor = model.mainColor
        }
        .store(in: &self.cancellables)
      self.bottomLine = line
    }
    
    open override func becomeFirstResponder() -> Bool {
      configuration.groupEditModel.map { model in
        switch model.bottomLineDisplayMode {
        case .always, .editing:
          bottomLine.isHidden = false
        case .none:
          bottomLine.isHidden = true
        }
      }
      return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
      configuration.groupEditModel.map { model in
        switch model.bottomLineDisplayMode {
        case .always:
          bottomLine.isHidden = false
        case .editing, .none:
          bottomLine.isHidden = true
        }
      }
      return super.resignFirstResponder()
    }
  }
}

extension Styled.UITextField {
  public enum Configuration: Equatable {
    var primaryModel: PrimaryModel? {
      if case let .primary(model) = self {
        return model
      }
      return nil
    }
    
    var groupEditModel: GroupEditModel? {
      if case let .groupEdit(model) = self {
        return model
      }
      return nil
    }
    
    case primary(PrimaryModel)
    case groupEdit(GroupEditModel)
  }
}

extension Styled.UITextField.Configuration {
  public struct PrimaryModel: Equatable {
    public static let standard = Self(
      cornerRadius: 10,
      image: UIImage.searchIconImage,
      imageLeadingConstant: 7,
      imageTrailingConstant: 4
    )
    
    let cornerRadius: CGFloat
    let image: UIImage?
    let imageLeadingConstant: CGFloat
    let imageTrailingConstant: CGFloat
  }
  
  public struct GroupEditModel: Equatable {
    public static let standard = Self(mainColor: UIColor.toDoGardenGreenDark, bottomLineDisplayMode: .always)
    public static let todoList = Self(mainColor: UIColor.toDoGardenRed, bottomLineDisplayMode: .editing)
    
    var mainColor: UIColor
    var image: UIImage = UIImage(systemName: "xmark.circle.fill") ?? UIImage.searchIconImage
    var bottomLineDisplayMode: DisPlayMode
  }
}

extension Styled.UITextField.Configuration.GroupEditModel {
  enum DisPlayMode: Equatable {
    case always
    case editing
    case none
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stack = UIStackView()
  stack.axis = .vertical
  stack.spacing = 20
  
  let textField1 = Styled.UITextField(configuration: .primary(.standard))
  textField1.placeholder = "아이디를 입력해주세요."
  stack.addArrangedSubview(textField1)
  let textField2 = Styled.UITextField(configuration: .groupEdit(.standard))
  textField2.placeholder = "아이디를 입력해주세요."
  stack.addArrangedSubview(textField2)
  
  let textField3 = Styled.UITextField(configuration: .groupEdit(.todoList))
  stack.addArrangedSubview(textField3)
  
  return stack
}
#endif
