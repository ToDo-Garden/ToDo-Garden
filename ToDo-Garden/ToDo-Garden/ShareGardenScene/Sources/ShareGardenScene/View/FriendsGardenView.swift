//
//  FriendsGardenView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/20/24.
//

import UIKit

import TDUtility
import ToDoGardenUIConstant
import ToDoGardenUIResource

extension ShareGardenSceneViewController {
  final class FriendsGardenView: UIStackView {
    
    // MARK: - UI Properties
    
    private let sectionHeaderView: SectionHeaderView = {
      let editButton = UIButton()
      let editButtonTitle = ShareGardenSceneViewController.Constant
        .StringLiteral.FriendsGardenSectionHeaderView.rightActionButtonTitle
      editButton.setTitle(editButtonTitle, for: UIControl.State.normal)
      editButton.setTitleColor(UIColor.toDoGardenEditButtonOrange, for: UIControl.State.normal)
      editButton.setTitleColor(UIColor.toDoGardenGray, for: UIControl.State.highlighted)
      editButton.titleLabel?.font = UIFont.pretendardDetailRegular12
      editButton.usingAutolayout()
      editButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
      editButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
      
      let title = ShareGardenSceneViewController.Constant
        .StringLiteral.FriendsGardenSectionHeaderView.title
      
      return SectionHeaderView(sectionTitle: title, rightActionButton: editButton)
    }()
    
    private let searchGardenButton: UIButton = {
      let searchGardenButton = UIButton()
      searchGardenButton.searchGardenButtonStyle()
      
      return searchGardenButton
    }()
    
    // MARK: - Properties
    
    @ExecuteOnce private var setupLayoutIfNeeded: (() -> Void)?
    
    init() {
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.setupLayoutIfNeeded = {
        self.setupLayoutConstraints()
      }
    }
  }
}

// MARK: - Setup view appearance

extension ShareGardenSceneViewController.FriendsGardenView {
  private func setup() {
    self.setupStackView()
    self.addSubviews()
  }
  
  private func setupStackView() {
    self.spacing = 15
    self.distribution = UIStackView.Distribution.fill
    self.axis = NSLayoutConstraint.Axis.vertical
    self.alignment = UIStackView.Alignment.center
  }
  
  private func addSubviews() {
    self.addArrangedSubview(self.sectionHeaderView)
    self.addArrangedSubview(self.searchGardenButton)
  }
}

// MARK: - Setup layout constraints

extension ShareGardenSceneViewController.FriendsGardenView {
  private func setupLayoutConstraints() {
    self.setupSectionHeaderViewLayoutConstraints()
    self.setupSearchGardenButtonLayoutConstraints()
  }
  
  private func setupSectionHeaderViewLayoutConstraints() {
    let leftInset: CGFloat = self.bounds.width * (28 / 375)
    let rightInset: CGFloat = self.bounds.width * (22 / 375)
    
    self.sectionHeaderView.layoutMargins = UIEdgeInsets(
      top: CGFloat.zero,
      left: leftInset,
      bottom: CGFloat.zero,
      right: rightInset
    )
    self.sectionHeaderView.isLayoutMarginsRelativeArrangement = true
    
    self.sectionHeaderView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.sectionHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.sectionHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
  
  private func setupSearchGardenButtonLayoutConstraints() {
    let horizontalInset: CGFloat = self.bounds.width * (19 / 375)
    
    self.searchGardenButton.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.searchGardenButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
      self.searchGardenButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalInset)
    ])
  }
}
