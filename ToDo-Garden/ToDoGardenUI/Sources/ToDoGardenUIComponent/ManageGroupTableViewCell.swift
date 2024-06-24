//
//  ManageGroupListTableViewCell.swift
//
//
//  Created by SONG on 6/13/24.
//

import UIKit

import FoundationExtension
import ToDoGardenUIAPI

public class ManageGroupTableViewCell: UITableViewCell {
  private var configuration: ManageGroupTableViewCell.Configuration?
  
  private var progressCircle: CircularProgressView?
  private var groupNameButton: UIButton?
  private var rightImageButton: UIButton?
  
  private var rightButtonActionHandler: ((UIColor, String) -> Void)?
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.configuration = nil
    self.progressCircle = nil
    self.groupNameButton = nil
    self.rightImageButton = nil
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.backgroundColor = UIColor.clear
    self.selectionStyle = UITableViewCell.SelectionStyle.none
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    self.progressCircle?.removeFromSuperview()
    self.groupNameButton?.removeFromSuperview()
    self.rightImageButton?.removeFromSuperview()
  }
  
  public func startAnimation() {
    self.progressCircle?.startAnimation(
      duration: 0.5,
      from: Float.zero,
      to: self.configuration?.model?.progressCircle.progressRate.value ?? Float.zero
    )
  }
  
  public func enterEditingMode() {
    self.showRightImageButton()
    self.animateAppear()
  }
  
  public func leaveEditingMode() {
    let isSecondaryStyle = self.configuration?.model?.groupNameButton.isCreateToDoButton
    if isSecondaryStyle == true {
      return
    }
    self.animateDisappear()
  }
  
  public func applyModelPrimary(
    id: String,
    groupName: String,
    progressColor: UIColor,
    progressRate: Float
  ) {
    self.configuration = Configuration.init(
      style: Configuration.Style.primary(
        id: id,
        groupName: groupName,
        progressColor: progressColor,
        progressRate: progressRate
      )
    )
    
    self.build()
    self.startAnimation()
  }
  
  public func applyModelSecondary(
    id: String,
    groupName: String,
    progressColor: UIColor,
    progressRate: Float
  ) {
    self.configuration = Configuration.init(
      style: Configuration.Style.secondary(
        id: id,
        groupName: groupName,
        progressColor: progressColor,
        progressRate: progressRate
      )
    )
    
    self.build()
    self.startAnimation()
  }
  
  public func update(color: UIColor? = nil, progressRate: Float? = nil, groupName: String? = nil) {
    
    if let color = color {
      self.updateColorOfProgressCircle(color: color)
    }
    
    if let progressRate = progressRate {
      self.updateProgressRate(rate: progressRate)
    }
    
    if let groupName = groupName {
      self.updateTextOfGroupName(name: groupName)
    }
    self.startAnimation()
  }
  
  public func setupRightButtonAction(handler: @escaping (UIColor, String) -> Void) {
    self.rightButtonActionHandler = handler
    self.rightImageButton?.addAction(UIAction { [weak self] _ in
      self?.handleRightButtonAction()
      
    }, for: UIControl.Event.touchUpInside)
  }
  
  private func handleRightButtonAction() {
    if let color = configuration?.model?.progressCircle.progressColor.value,
    let groupName = configuration?.model?.groupNameButton.groupName.value {
      self.rightButtonActionHandler?(color, groupName)
    }
  }
  
  public func getIdentifier() -> String {
    return Self.identifier
  }
}

// MARK: - Build Views
extension ManageGroupTableViewCell {
  private func build() {
    self.buildProgressCircle()
    self.buildGroupNameButton()
    self.buildRightImageButton()
    self.bind()
  }
  
  private func buildProgressCircle() {
    guard let model = self.configuration?.model?.progressCircle else {
      return
    }
    
    self.progressCircle = CircularProgressView(
      progressColor: model.progressColor.value,
      backgroundColor: model.backgroundColor,
      lineWidth: model.lineWidth
    )
    
    guard let progressCircle = self.progressCircle else {
      return
    }
    
    progressCircle.usingAutolayout()
    
    self.contentView.addSubview(progressCircle)
    NSLayoutConstraint.activate(
      [
        progressCircle.leadingAnchor.constraint(
          equalTo: self.contentView.leadingAnchor,
          constant: model.leading
        ),
        progressCircle.widthAnchor.constraint(equalToConstant: model.size.width),
        progressCircle.heightAnchor.constraint(equalToConstant: model.size.height),
        progressCircle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
      ]
    )
  }
  
  private func buildGroupNameButton() {
    guard let model = self.configuration?.model?.groupNameButton else {
      return
    }
    
    self.initializeGroupNameButton(with: model)
    
    guard let groupNameButton = self.groupNameButton, let progressCircle = self.progressCircle else {
      return
    }
    
    self.configureGroupNameButtonAppearance(groupNameButton, with: model)
    self.addGroupNameButtonConstraints(groupNameButton, progressCircle, with: model)
  }
  
  private func initializeGroupNameButton(with model: Configuration.Model.GroupNameButton) {
    if model.isCreateToDoButton {
      self.groupNameButton = CreateToDoButton(model: CreateToDoButton.Model.primary)
    } else {
      self.groupNameButton = UIButton(configuration: UIButton.Configuration.plain())
      self.groupNameButton?.backgroundColor = UIColor.toDoGardenGreenBackground
      self.groupNameButton?.layer.cornerRadius = model.cornerRadius
      self.groupNameButton?.configuration?.contentInsets = model.contentInsets
    }
  }
  
  private func configureGroupNameButtonAppearance(
    _ groupNameButton: UIButton,
    with model: Configuration.Model.GroupNameButton
  ) {
    groupNameButton.configuration?.titleLineBreakMode = NSLineBreakMode.byTruncatingTail
    groupNameButton.setAttributedTitle(
      self.attributedButtonTitle(with: model.groupName.value),
      for: UIControl.State.normal
    )
    groupNameButton.usingAutolayout()
    self.contentView.addSubview(groupNameButton)
  }
  
  private func addGroupNameButtonConstraints(
    _ groupNameButton: UIButton,
    _ progressCircle: UIView,
    with model: Configuration.Model.GroupNameButton
  ) {
    NSLayoutConstraint.activate(
      [
        groupNameButton.leadingAnchor.constraint(equalTo: progressCircle.trailingAnchor, constant: model.leading),
        groupNameButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        groupNameButton.heightAnchor.constraint(equalToConstant: model.height),
        groupNameButton.widthAnchor.constraint(
          lessThanOrEqualTo: self.contentView.widthAnchor,
          multiplier: model.widthMultiplier)
      ]
    )
  }
}
