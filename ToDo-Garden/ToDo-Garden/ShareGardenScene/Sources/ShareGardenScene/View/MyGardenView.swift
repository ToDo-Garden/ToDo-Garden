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

import ShareGardenSceneEntity

extension ShareGardenSceneViewController {
  final class MyGardenView: UIStackView {
    
    // MARK: - UI Properties
    
    private let retryRequestView: RetryRequestView = RetryRequestView()
    private let contentView: UIStackView
    
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
    
    var retryAction: UIAction? {
      didSet {
        self.retryRequestView.retryAction = self.retryAction
      }
    }
    
    init() {
      self.contentView = UIVStackView(
        alignment: UIStackView.Alignment.center,
        spacing: 14,
        arrangedSubviews: [
          self.profileInfoView,
          self.gardenView
        ]
      )
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
    
    func update(viewModel: ShareGardenScene.RequestMyGarden.ViewModel) {
      self.updateGardenView(with: viewModel.pomodoroRecords)
      self.updateProfileInfoView(with: viewModel.nickname, viewModel.description)
      self.stopShimmeringAnimation()
    }
    
    func startShimmeringAnimation() {
      self.layoutIfNeeded()
      self.profileInfoView.startShimmering()
    }
    
    func showContentsLoadingFailure() {
      self.removeArrangedSubview(self.contentView)
      self.addArrangedSubview(self.retryRequestView.view)
      self.contentView.isHidden = true
      self.retryRequestView.view.isHidden = false
      self.stopShimmeringAnimation()
    }
    
    func showContents() {
      self.addArrangedSubview(self.contentView)
      self.removeArrangedSubview(self.retryRequestView.view)
      self.contentView.isHidden = false
      self.retryRequestView.view.isHidden = true
      self.startShimmeringAnimation()
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
    self.addArrangedSubview(self.contentView)
    self.addSpacerAtLast()
  }
  
  private func addSpacerAtLast() {
    let spacer = UIView()
    spacer.setContentHuggingPriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.vertical
    )
    spacer.setContentCompressionResistancePriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.vertical
    )
    self.addArrangedSubview(spacer)
  }
  
  private func updateProfileInfoView(with nickname: String, _ description: String) {
    self.profileInfoView.configuration = Styled.Row.Configuration.profile(
      Styled.Row.Configuration.ProfileModel(
        style: Styled.Row.Configuration.ProfileModel.Style.shareProfile,
        title: nickname,
        description: description
      )
    )
  }
  
  private func updateGardenView(with pomodoroRecordCollection: PomodoroRecordCollection) {
    self.gardenView.configure(with: pomodoroRecordCollection)
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = ShareGardenSceneViewController.MyGardenView()
  return view
}
#endif
