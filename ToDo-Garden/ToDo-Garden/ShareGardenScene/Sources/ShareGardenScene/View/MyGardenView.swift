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
      let shareButtonSize = MyGardenView.layoutConstant.shareButtonSize
      let shareButton = UIButton()
      shareButton.setImage(UIImage.shareIconImage, for: UIControl.State.normal)
      let title = ShareGardenSceneViewController.Constant.StringLiteral.MyGardenSectionHeaderView.title
      shareButton.usingAutolayout()
      shareButton.widthAnchor.constraint(equalToConstant: shareButtonSize.width).isActive = true
      shareButton.heightAnchor.constraint(equalToConstant: shareButtonSize.height).isActive = true
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
    
    override var intrinsicContentSize: CGSize {
      let contentHeight = Constant.Layout.MyGardenView.contentHeight
      return CGSize(width: super.intrinsicContentSize.width, height: contentHeight)
    }
    
    private static let layoutConstant = Constant.Layout.MyGardenView.self
    
    var retryAction: UIAction? {
      didSet {
        self.retryRequestView.retryAction = self.retryAction
      }
    }
    
    init() {
      let contentViewSpacing = Self.layoutConstant.contentViewSpacing
      self.contentView = UIVStackView(
        alignment: UIStackView.Alignment.center,
        spacing: contentViewSpacing,
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
    
    func showRetryRequestView() {
      self.removeArrangedSubview(self.contentView)
      self.insertArrangedSubview(self.retryRequestView.view, at: 1)
      self.contentView.isHidden = true
      self.retryRequestView.view.isHidden = false
      self.stopShimmeringAnimation()
    }
    
    func showMyGardenView() {
      self.insertArrangedSubview(self.contentView, at: 1)
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
    self.spacing = Self.layoutConstant.stackViewSpacing
    self.setCustomSpacing(Self.layoutConstant.spacerTopInset, after: self.contentView)
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
    let leftInset: CGFloat = self.bounds.width * Self.layoutConstant.sectionHeaderViewLeftInsetRatio
    let rightInset: CGFloat = self.bounds.width * Self.layoutConstant.sectionHeaderViewRightInsetRatio
    
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
