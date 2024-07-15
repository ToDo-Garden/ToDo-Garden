import Combine
import UIKit

import CombineExtension
import ToDoGardenUIAPI
import ToDoGardenUIConstant

public final class ColorPickerList: UIStackView, ColorPickerListAPI {
  let itemsPerRow: Int
  public let colors: [UIColor]
  public var selected: CurrentValueSubject<Int?, Never>
  private var cancellables: Set<AnyCancellable> = []
  
  public init(
    colors: [UIColor],
    itemsPerRow: Int,
    selected: Int?
  ) {
    self.colors = colors
    self.itemsPerRow = itemsPerRow
    self.selected = CurrentValueSubject<Int?, Never>(selected)
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  public init(
    colors: [UIColor],
    itemsPerRow: Int,
    selected: CurrentValueSubject<Int?, Never>
  ) {
    self.colors = colors
    self.itemsPerRow = itemsPerRow
    self.selected = selected
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  public required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func build() {
    self.axis = NSLayoutConstraint.Axis.vertical
    self.spacing = Constant.ColorPickerList.spacing
    let colors = self.colors.splitArray(itemsPerRow)
    colors
      .enumerated()
      .forEach { column, colorList in
        let subViews = colorList
          .enumerated()
          .map { ((column * itemsPerRow) + $0.offset, $0.element) }
          .map(buildColorButton)
        let stack = UIStackView(arrangedSubviews: subViews)
        if subViews.count != itemsPerRow {
          stack.addArrangedSubview(UIView())
        }
        stack.spacing = Constant.ColorPickerList.spacing
        self.addArrangedSubview(stack)
      }
  }
  
  private func buildColorButton(index: Int, backgroundColor: UIColor) -> UIButton {
    let button = ColorButton(color: backgroundColor)
    self.buildColorButtonConfiguration(button, index: index)
    self.buildColorButtonLayout(button)
    self.selected
      .pairwise()
      .sink { [weak button] old, new in
        guard let button 
        else { return }
        if index == old, old != new {
          button.isSelected = false
        }
        if new == index, !button.isSelected {
          button.isSelected.toggle()
        }
      }
      .store(in: &self.cancellables)
    
    return button
  }
  
  private func buildColorButtonConfiguration(_ button: UIButton, index: Int) {
    let action = UIAction { [weak self] _ in
      self?.selected.send(index)
    }
    button.addAction(action, for: UIControl.Event.touchUpInside)
    if selected.value == index {
      button.isSelected = true
    }
  }
  
  private func buildColorButtonLayout(_ button: UIButton) {
    button.usingAutolayout()
    let width = Constant.ColorPickerList.buttonSize.width
    let height = Constant.ColorPickerList.buttonSize.height
    NSLayoutConstraint.activate([
      button.widthAnchor.constraint(equalToConstant: width),
      button.heightAnchor.constraint(equalToConstant: height)
    ])
  }
}

private final class ColorButton: UIButton {
  private var padding: CGFloat
  
  override var isSelected: Bool {
    didSet {
      self.layer.borderWidth = isSelected
      ? Constant.ColorPickerList.buttonSelectedBorderWidth
      : Constant.ColorPickerList.buttonNormalBorderWidth
    }
  }
  
  init(
    padding: CGFloat = Constant.ColorPickerList.buttonPadding,
    color: UIColor,
    selectedColor: UIColor? = UIColor.toDoGardenGray
  ) {
    self.padding = padding
    super.init(frame: .zero)
    self.build(backgroundColor: color, selectedColor: selectedColor)
  }
  
  @available(*, unavailable)
  fileprivate required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate override func layoutSubviews() {
    super.layoutSubviews()
    if
      let configuration,
      configuration.background.cornerRadius != self.bounds.width / 2 {
      self.configuration?.background.cornerRadius = self.bounds.width / 2
    }
    if self.layer.cornerRadius != self.bounds.width / 2 {
      self.layer.cornerRadius = self.bounds.width / 2
    }
  }
  
  private func build(backgroundColor: UIColor, selectedColor: UIColor?) {
    self.buildConfiguration(backgroundColor)
    if let selectedColor {
      self.layer.borderColor = selectedColor.cgColor
    }
  }
  
  private func buildConfiguration(_ backgroundColor: UIColor) {
    self.configuration = UIButton.Configuration.filled()
    self.configuration?.background.backgroundInsets = NSDirectionalEdgeInsets(
      top: self.padding,
      leading: self.padding,
      bottom: self.padding,
      trailing: self.padding
    )
    self.configuration?.background.backgroundColor = backgroundColor
    self.changesSelectionAsPrimaryAction = true
  }
}

private extension Array {
  func splitArray(_ itemsPerRow: Int) -> [[Element]] {
    var result: [[Element]] = []
    for index in stride(from: 0, to: self.count, by: itemsPerRow) {
      let endIndex = Swift.min(index + itemsPerRow, self.count)
      let row = Array(self[index..<endIndex])
      result.append(row)
    }
    
    return result
  }
}

@available(iOS 17.0, *)
#Preview {
  let subject =  CurrentValueSubject<Int?, Never>(nil)
  let view = ColorPickerList(
    colors: [
      UIColor.gray, UIColor.red, UIColor.green, UIColor.blue,
      UIColor.gray, UIColor.red, UIColor.green, UIColor.blue,
      UIColor.gray, UIColor.red, UIColor.green, UIColor.blue
    ],
    itemsPerRow: 4,
    selected: subject
  )
  subject.send(3)
  
  return view
}
