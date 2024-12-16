import Combine
import UIKit

import ToDoGardenUIConstant

private typealias ViewMode = UIKit.UITextField.ViewMode

extension Styled {
  public final class TextField: UITextField {
    public var mainColor: UIColor? {
      get {
        if let model = self.configuration.groupEditModel {
          return model.mainColor
        }
        return nil
      }
      set {
        if var model = self.configuration.groupEditModel, let newValue {
          model.mainColor = newValue
          self.configuration = Configuration.groupEdit(model)
        }
      }
    }
    
    @Published var configuration: Configuration
    var bottomLine: UIProgressView!
    var cancellables: Set<AnyCancellable> = []
    
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
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.textRect(forBounds: bounds)
      return self.buildLeftImageMargin(rect)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.textRect(forBounds: bounds)
      return self.buildLeftImageMargin(rect)
    }
    
    public override func becomeFirstResponder() -> Bool {
      configuration.groupEditModel.map { model in
        switch model.bottomLineDisplayMode {
        case Configuration.GroupEditModel.DisPlayMode.always,
          Configuration.GroupEditModel.DisPlayMode.editing:
          self.animateBottomLineAppearing()
        case Configuration.GroupEditModel.DisPlayMode.none:
          self.animateBottomLineAppearing()
        }
      }
      return super.becomeFirstResponder()
    }

    private func animateBottomLineAppearing() {
      let duration = Constant.Styled.TextField.GroupEdit.BottomLineAnimation.duration
      UIView.animate(withDuration: duration) {
        self.bottomLine.setProgress(1.0, animated: true)
      }
    }

    public override func resignFirstResponder() -> Bool {
      configuration.groupEditModel.map { model in
        switch model.bottomLineDisplayMode {
        case Configuration.GroupEditModel.DisPlayMode.always:
          self.bottomLine.setProgress(0.0, animated: false)
        case Configuration.GroupEditModel.DisPlayMode.editing,
          Configuration.GroupEditModel.DisPlayMode.none:
          self.bottomLine.setProgress(0.0, animated: false)
        }
      }
      return super.resignFirstResponder()
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
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
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
      case let Configuration.primary(primaryModel):
        self.buildPrimaryView(model: primaryModel)
      case let Configuration.groupEdit(groupEditModel):
        self.buildGroupEditStyle(model: groupEditModel)
      }
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stack = UIStackView()
  stack.axis = .vertical
  stack.spacing = 20
  
  let textField1 = Styled.TextField(configuration: .primary(.standard))
  textField1.placeholder = "아이디를 입력해주세요."
  stack.addArrangedSubview(textField1)
  let textField2 = Styled.TextField(configuration: .groupEdit(.standard))
  textField2.placeholder = "아이디를 입력해주세요."
  stack.addArrangedSubview(textField2)
  
  let textField3 = Styled.TextField(configuration: .groupEdit(.todoList(mainColor: .red)))
  stack.addArrangedSubview(textField3)
  
  return stack
}
#endif
