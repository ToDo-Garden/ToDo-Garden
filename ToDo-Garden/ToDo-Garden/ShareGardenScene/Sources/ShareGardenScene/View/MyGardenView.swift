//
//  MyGardenView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/13/24.
//

import UIKit

import TDUtility
import ToDoGardenUIComponent
import ToDoGardenUIResource

extension ShareGardenSceneViewController {
  final class MyGardenView: UIStackView {
    
    // MARK: - UI Properties
    
    private let sectionHeaderView: SectionHeaderView = {
      let shareButton = UIButton()
      shareButton.setImage(UIImage.shareIconImage, for: UIControl.State.normal)
      let title = ShareGardenSceneViewController.Constant.StringLiteral.MyGardenSectionHeaderView.title
      shareButton.usingAutolayout()
      shareButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
      shareButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
      shareButton.setTitleColor(UIColor.darkGray, for: UIControl.State.highlighted)
      
      let sectionHeaderView = SectionHeaderView(
        sectionTitle: title,
        rightActionButton: shareButton
      )
      
      return sectionHeaderView
    }()
    
    private let profileInfoView: Styled.Row = {
      let nicknamePlaceholder = ShareGardenSceneViewController.Constant
        .StringLiteral.ProfileInfoView.nicknamePlaceholder
      let descriptionPlaceholder = ShareGardenSceneViewController.Constant
        .StringLiteral.ProfileInfoView.descriptionPlaceholder
      
      let profileInfoView = Styled.Row(
        configuration: Styled.Row.Configuration.profile(
          Styled.Row.Configuration.ProfileModel(
            style: Styled.Row.Configuration.ProfileModel.Style.shareProfile,
            title: nicknamePlaceholder,
            description: descriptionPlaceholder
          )
        )
      )
      
      return profileInfoView
    }()
    
    private let gardenView: GardenView = GardenView()
    
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
    
    func configure(with pomodoroRecordCollection: PomodoroRecordCollection) {
      self.gardenView.configure(with: pomodoroRecordCollection)
    }
    
    func startShimmeringAnimation() {
      self.layoutIfNeeded()
      self.profileInfoView.startShimmering()
    }
  }
}

// MARK: - Setup view appearance

extension ShareGardenSceneViewController.MyGardenView {
  private func setup() {
    self.setupStackView()
    self.addSubviews()
  }
  
  private func setupStackView() {
    self.spacing = 14
    self.distribution = UIStackView.Distribution.fill
    self.axis = NSLayoutConstraint.Axis.vertical
    self.alignment = UIStackView.Alignment.center
  }
  
  private func addSubviews() {
    self.addArrangedSubview(self.sectionHeaderView)
    self.addArrangedSubview(self.profileInfoView)
    self.addArrangedSubview(self.gardenView)
  }
  
  private func stopShimmeringAnimation() {
    self.profileInfoView.stopShimmering()
  }
}

// MARK: - Setup layout constraints

extension ShareGardenSceneViewController.MyGardenView {
  private func setupLayoutConstraints() {
    self.setupSectionHeaderViewLayoutConstraints()
    self.setupProfileInfoViewLayoutConstraints()
  }
  
  private func setupSectionHeaderViewLayoutConstraints() {
    let leftInset: CGFloat = self.bounds.width * (28 / 375)
    let rightInset: CGFloat = self.bounds.width * (24 / 375)
    
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
  
  private func setupProfileInfoViewLayoutConstraints() {
    self.profileInfoView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.profileInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.profileInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
