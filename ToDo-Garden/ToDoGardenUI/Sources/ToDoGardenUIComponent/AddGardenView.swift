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
  private var profileView: Styled.Row
  private var gardenView: GardenView
  typealias Constants = Constant.AddGardenView
  
  public init(
    userNickname: String,
    userIntroduction: String,
    userImage: UIImage?,
    pomodoroCollection: PomodoroRecordCollection
  ) {
    self.titleLabel = UILabel()
    self.cancelButton = UIButton(configuration: UIButton.Configuration.borderless())
    self.addButton = ToDoGardenBoxButton(
      title: Constants.StringLiteral.addButtonTitle,
      buttonType: ToDoGardenBoxButton.Configuration.tertiaryRoundRectButton
    )
    
    self.profileView = Styled.Row(
      configuration: Styled.Row.Configuration.profile(
        .init(
          style: Styled.Row.Configuration.ProfileModel.Style.myStats,
          title: userNickname,
          description: userIntroduction,
          image: userImage
        )
      )
    )
    
    self.gardenView = GardenView()
    self.gardenView.configure(with: pomodoroCollection)
    
    super.init(frame: CGRect.zero)
    self.setupAppearance()
    self.setupSubViews()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public var intrinsicContentSize: CGSize {
    return Constants.Layout.size
  }
  
  public func update(
    userNickname: String,
    userIntroduction: String,
    userImage: UIImage?,
    pomodoroCollection: PomodoroRecordCollection
  ) {
    self.profileView.removeFromSuperview()
    
    self.profileView = Styled.Row(
      configuration: Styled.Row.Configuration.profile(
        .init(
          style: Styled.Row.Configuration.ProfileModel.Style.myStats,
          title: userNickname,
          description: userIntroduction,
          image: userImage
        )
      )
    )
    self.addSubview(self.profileView)
    self.setupProfileViewConstraints()
    
    self.gardenView.configure(with: pomodoroCollection)
  }
}

extension AddGardenView {
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = Constants.Layout.cornerRadius
  }
  
  private func setupSubViews() {
    self.setupTitleLabel()
    self.setupCancelButton()
    self.setupAddButton()
    
    self.addSubview(self.profileView)
    self.addSubview(self.gardenView)
    
    self.setupProfileViewConstraints()
    self.setupGardenViewConstraints()
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
  
  private func setupProfileViewConstraints() {
    self.profileView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.profileView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.profileView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.profileView.topAnchor.constraint(
          equalTo: self.titleLabel.bottomAnchor,
          constant: Constants.Layout.commonHorizontalMargin
        )
      ]
    )
  }
  
  private func setupGardenViewConstraints() {
    self.gardenView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.gardenView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constants.Layout.commonHorizontalMargin
        ),
        self.gardenView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constants.Layout.commonHorizontalMargin
        ),
        self.gardenView.bottomAnchor.constraint(
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
  
  view.update(
    userNickname: "zxc",
    userIntroduction: "asdasdasdasdasdasd",
    userImage: nil,
    pomodoroCollection: PomodoroRecordCollection()
  )
  return view
}
#endif
