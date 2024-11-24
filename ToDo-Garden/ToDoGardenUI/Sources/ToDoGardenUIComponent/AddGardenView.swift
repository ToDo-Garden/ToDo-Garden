//
//  AddGardenView.swift
//
//
//  Created by SONG on 11/24/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class AddGardenView: UIView {
  private let titleLabel: UILabel
  public let cancelButton: UIButton
  public let addButton: UIButton
  typealias Constants = Constant.AddGardenView
  
  public init(
    userNickname: String,
    userIntroduction: String,
    userImage: UIImage?,
    pomodoroCollection: PomodoroRecordCollection
  ) {
    self.titleLabel = UILabel()
    self.cancelButton = UIButton(configuration: .borderless())
    self.addButton = ToDoGardenBoxButton(
      title: Constants.StringLiteral.addButtonTitle,
      buttonType: .tertiaryRoundRectButton
    )
    
    super.init(frame: CGRect.zero)
    self.setupAppearance()
    self.setupSubViews(
      userNickname: userNickname,
      userIntroduction: userIntroduction,
      userImage: userImage,
      pomodoroCollection: pomodoroCollection
    )
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public var intrinsicContentSize: CGSize {
    return Constants.Layout.size
  }
}

extension AddGardenView {
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = Constants.Layout.cornerRadius
  }
  
  private func setupSubViews(
    userNickname: String,
    userIntroduction: String,
    userImage: UIImage?,
    pomodoroCollection: PomodoroRecordCollection
  ) {
    
    self.setupTitleLabel()
    self.setupCancelButton()
    self.setupAddButton()
    self.setupProfileView(userNickname: userNickname, userIntroduction: userIntroduction, userImage: userImage)
    self.setupGardenView(pomodoroCollection: pomodoroCollection)
  }
  
  private func setupTitleLabel() {
    let title = Constant.AddGardenView.StringLiteral.labelTitle
    self.titleLabel.attributedText = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.titleLabel.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: Constants.Layout.commonMargin
        )
      ]
    )
  }
  
  private func setupCancelButton() {
    let title = Constants.StringLiteral.cancelButtonTitle
    let attributedString = AttributedString(
      title.applyTextAttributes(
        attributes: [
          NSAttributedString.Key.font: UIFont.pretendardBodyRegular,
          NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
        ]
      )
    )
    self.cancelButton.configuration?.attributedTitle = attributedString
    self.addSubview(self.cancelButton)
    self.cancelButton.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.cancelButton.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constants.Layout.commonMargin
        ),
        self.cancelButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
      ]
    )
  }
  
  private func setupProfileView(userNickname: String, userIntroduction: String, userImage: UIImage?) {
    let profileView = Styled.Row(
      configuration: Styled.Row.Configuration.profile(
        .init(
          style: .myStats,
          title: userNickname,
          description: userIntroduction,
          image: userImage
        )
      )
    )
    self.addSubview(profileView)
    profileView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        profileView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        profileView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        profileView.topAnchor.constraint(
          equalTo: self.titleLabel.bottomAnchor,
          constant: Constants.Layout.commonHorizontalMargin
        )
      ]
    )
  }
  
  private func setupGardenView(pomodoroCollection: PomodoroRecordCollection) {
    let gardenView = GardenView()
    gardenView.configure(with: pomodoroCollection)
    self.addSubview(gardenView)
    gardenView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        gardenView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constants.Layout.commonHorizontalMargin
        ),
        gardenView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constants.Layout.commonHorizontalMargin
        ),
        gardenView.bottomAnchor.constraint(
          equalTo: self.addButton.topAnchor,
          constant: Constants.GardenView.Layout.verticalMargin
        )
      ]
    )
  }
  
  private func setupAddButton() {
    self.addButton.usingAutolayout()
    self.addSubview(self.addButton)
    NSLayoutConstraint.activate(
      [
        self.addButton.bottomAnchor.constraint(
          equalTo: self.bottomAnchor,
          constant: Constants.AddButton.Layout.bottomMargin
        ),
        self.addButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = AddGardenView(
    userNickname: "울버린",
    userIntroduction: "안녕하세욤ㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅁㄴㅇㅁㄴㅇㅁㄴㅇ",
    userImage: nil,
    pomodoroCollection: PomodoroRecordCollection()
  )
  
  view.usingAutolayout()
  view.widthAnchor.constraint(equalToConstant: 320).isActive = true
  view.heightAnchor.constraint(equalToConstant: 390).isActive = true
  return view
}
#endif
