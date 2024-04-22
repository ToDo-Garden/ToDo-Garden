import UIKit

public enum Styled { }

extension Styled {
  open class UITextField: UIKit.UITextField {
    public var configuration: Configuration
    
    public init(configuration: Configuration) {
      self.configuration = configuration
      super.init(frame: .zero)
      build()
    }
    
    public required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.textRect(forBounds: bounds)
      return buildLeftImageMargin(rect)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
      let rect = super.textRect(forBounds: bounds)
      return buildLeftImageMargin(rect)
    }
    
    private func buildLeftImageMargin(_ rect: CGRect) -> CGRect {
      if let leftImage = configuration.leftImage, let trailing = leftImage.trailing {
        var insets = UIEdgeInsets.zero
        insets.left = trailing
        return rect.inset(by: insets)
      }
      
      return rect
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
      var rect = super.leftViewRect(forBounds: bounds)
      if let leftImage = configuration.leftImage {
        rect.origin.x = leftImage.leading
      }
      
      return rect
    }
    
    private func build() {
      clearButtonMode = .whileEditing
      // MAKRK: - Border
      if let border = configuration.border {
        layer.cornerRadius = border.cornerRadius
        layer.borderWidth = border.lineWidth
      }
      
      // MAKRK: - Left Image
      if let leftImage = configuration.leftImage {
        leftView = UIImageView(image: leftImage.image)
        leftViewMode = .always
      }
      
      // MARK: - Right Image
      if let rightImage = configuration.rightImage, let button = value(forKeyPath: "_clearButton") as? UIButton {
        button.setImage(rightImage.tintedImage, for: .normal)
      }
      
      // MARK: - Bottom Line
      if let color = configuration.bottomLineColor {
        buildBottomLine(color: color)
      }
    }
    
    private func buildBottomLine(color: UIColor) {
      let line = UIView()
      line.backgroundColor = color
      line.translatesAutoresizingMaskIntoConstraints = false
      addSubview(line)
      NSLayoutConstraint.activate([
        line.bottomAnchor.constraint(equalTo: bottomAnchor),
        line.leadingAnchor.constraint(equalTo: leadingAnchor),
        line.trailingAnchor.constraint(equalTo: trailingAnchor),
        line.heightAnchor.constraint(equalToConstant: 1)
      ])
    }
  }
}

extension Styled.UITextField {
  public struct Configuration {
    let border: Border?
    let leftImage: ImageData?
    var rightImage: ImageData?
    let bottomLineColor: UIColor?
    
    public init(
      border: Border? = nil,
      leftImage: ImageData? = nil,
      rightImage: ImageData? = nil,
      bottomLineColor: UIColor? = nil
    ) {
      self.border = border
      self.leftImage = leftImage
      self.rightImage = rightImage
      self.bottomLineColor = bottomLineColor
    }
  }
}

extension Styled.UITextField.Configuration {
  public struct Border {
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    
    public init(
      cornerRadius: CGFloat,
      lineWidth: CGFloat
    ) {
      self.cornerRadius = cornerRadius
      self.lineWidth = lineWidth
    }
  }
  
  public struct ImageData {
    let leading: CGFloat
    let trailing: CGFloat?
    
    let image: UIImage?
    var imageColor: UIColor?
    var tintedImage: UIImage? {
      image?.withTintColor(imageColor ?? .toDoGardenGreenDark)
    }
    
    public init(
      leading: CGFloat,
      trailing: CGFloat? = nil,
      image: UIImage?,
      imageColor: UIColor? = nil
    ) {
      self.leading = leading
      self.trailing = trailing
      self.image = image
      self.imageColor = imageColor
    }
  }
}

extension Styled.UITextField.Configuration {
  static let primary: Self = .init(
    border: .init(
      cornerRadius: 10,
      lineWidth: 0
    ),
    leftImage: .init(
      leading: 7,
      trailing: 4,
      image: .searchIconImage
    )
  )
  
  static let groupEdit: Self = .init(
    rightImage: .init(
      leading: 0,
      image: UIImage(systemName: "xmark.circle.fill"),
      imageColor: .toDoGardenGreenDark
    ),
    bottomLineColor: .toDoGardenGreenDark
  )
}

#if DEBUG
import SwiftUI

#Preview {
  VStack {
    WrappedView {
      let textField = Styled.UITextField(configuration: .primary)
      textField.placeholder = "아이디를 입력해주세요"
      textField.backgroundColor = .toDoGardenGreenBackground
      
      return textField
    }
    .frame(height: 40)
    
    WrappedView {
      let textField = Styled.UITextField(configuration: .groupEdit)
      textField.placeholder = "그룹명을 입력해주세요"
      
      return textField
    }
    .frame(height: 40)
  }
  .padding()
}
#endif
