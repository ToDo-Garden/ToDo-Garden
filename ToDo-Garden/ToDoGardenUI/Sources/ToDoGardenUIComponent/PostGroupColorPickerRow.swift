//
//  PostGroupColorPickerRow.swift
//
//
//  Created by SONG on 7/11/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

final class PostGroupColorPickerRow: UIView, PostGroupColorPickerRowAPI {
  private var listPrimaryRow: Styled.Row
  
  init() {
    self.listPrimaryRow = Styled.Row(
      configuration: Styled.Row.Configuration.listPrimary(
        Styled.Row.Configuration.ListPrimaryModel(
          title: "",
          color: UIColor.toDoGardenGray
        )
      )
    )
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getColor() -> UIColor? {
    return self.listPrimaryRow.groupListModel?.color
  }
  
  func updateColor(with color: UIColor) {
    self.listPrimaryRow.configuration = Styled.Row.Configuration.listPrimary(
      Styled.Row.Configuration.ListPrimaryModel(
        title: "", color: color
      )
    )
  }
  
  private func build() {
    self.buildRow()
    self.buildTitleLabel()
  }
  
  private func buildRow() {
    self.addSubview(self.listPrimaryRow)
    self.listPrimaryRow.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.listPrimaryRow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        self.listPrimaryRow.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.listPrimaryRow.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }
  
  private func buildTitleLabel() {
    let label = UILabel()
    let text = Constant.PostGroupColorPickerRow.StringLiteral.title
    label.attributedText = text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadSemiBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    label.backgroundColor = UIColor.white
    self.listPrimaryRow.addSubview(label)
    label.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        label.centerYAnchor.constraint(equalTo: self.listPrimaryRow.centerYAnchor),
        label.leadingAnchor.constraint(
          equalTo: self.listPrimaryRow.leadingAnchor,
          constant: Constant.PostGroupColorPickerRow.Layout.TitleLabel.leading
        )
      ]
    )
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = PostGroupColorPickerRow()
  
  view.usingAutolayout()
  NSLayoutConstraint.activate(
    [
      view.widthAnchor.constraint(equalToConstant: 300),
      view.heightAnchor.constraint(equalToConstant: 50)
    ]
  )
  
  let button = UIButton()
  button.setImage(UIImage.forwardButtonImage, for: .normal)
  view.addSubview(button)
  button.usingAutolayout()
  
  NSLayoutConstraint.activate(
    [
      button.centerXAnchor.constraint(equalTo: view.trailingAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
  )
  
  return view
}
