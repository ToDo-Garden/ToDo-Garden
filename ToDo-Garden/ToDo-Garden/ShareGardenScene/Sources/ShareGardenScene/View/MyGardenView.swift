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
      
      let sectionHeaderView = SectionHeaderView(
        sectionTitle: "나의 가든",
        rightActionButton: shareButton
      )
      
      return sectionHeaderView
    }()
    
    private let profileInfoView: Styled.Row = {
      let profileInfoView = Styled.Row(
        configuration: Styled.Row.Configuration.profile(
          Styled.Row.Configuration.ProfileModel.primary(
            title: "이인우",
            description: "함께하는 걸 좋아하는 iOS개발자"
          )
        )
      )
      
      return profileInfoView
    }()
    
    // MARK: - Properties
    
    @ExecuteOnce private var setupLayoutIfNeeded: (() -> Void)?
    
    init() {
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.setupLayoutIfNeeded = {
        self.setupLayoutConstraints()
        self.setupShimmering()
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

extension ShareGardenSceneViewController.MyGardenView {
  private func setup() {
    self.setupStackView()
    self.addSubviews()
  }
  
  private func setupStackView() {
    self.spacing = 14
    self.distribution = UIStackView.Distribution.fillEqually
    self.axis = NSLayoutConstraint.Axis.vertical
    self.alignment = UIStackView.Alignment.fill
  }
  
  private func addSubviews() {
    self.addArrangedSubview(self.sectionHeaderView)
    self.addArrangedSubview(self.profileInfoView)
  }
}

extension ShareGardenSceneViewController.MyGardenView {
  private func setupLayoutConstraints() {
    self.setupSectionHeaderViewLayoutConstraints()
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
  }
}

extension ShareGardenSceneViewController.MyGardenView {
  private func setupShimmering() {
    self.setupProfileInfoViewShimmering()
  }
  
  private func setupProfileInfoViewShimmering() {
    var stack = profileInfoView.subviews
    
    while stack.isEmpty == false {
      let currentView = stack.removeLast()
      currentView.isShimmering = true
      
      stack.append(contentsOf: currentView.subviews)
    }
  }
}
