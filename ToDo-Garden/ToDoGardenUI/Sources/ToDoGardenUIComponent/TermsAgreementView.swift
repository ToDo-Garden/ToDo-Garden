//
//  TermsAgreementView.swift
//
//  Created by SONG on 9/23/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public protocol TermsAgreementViewDelegate: AnyObject {
  func termsAgreementView(_ view: TermsAgreementView, didTapTermsAndPoliciesAgreement: Void)
  func termsAgreementView(_ view: TermsAgreementView, didTapPrivacyPolicy: Void)
  func termsAgreementView(_ view: TermsAgreementView, didTapEventAndPromotionalInformation: Void)
  func termsAgreementView(_ view: TermsAgreementView, didTapDoneButton isEventAndPromotionalInformationAgreed: Bool)
}

public final class TermsAgreementView: UIView {
  // MARK: - Properties
  private let agreeToAllRow: TermsAgreementViewRow
  private let termsAndPoliciesAgreementRow: TermsAgreementViewRow
  private let privacyPolicyRow: TermsAgreementViewRow
  private let eventAndPromotionalInformationRow: TermsAgreementViewRow
  
  private let doneButton: ToDoGardenBoxButton
  
  public weak var delegate: TermsAgreementViewDelegate?
  
  // MARK: - Initialization
  // swiftlint:disable function_body_length
  public init() {
    self.agreeToAllRow = TermsAgreementViewRow(
      title: Constant.TermsAgreementView.StringLiteral.agreeAll,
      font: UIFont.pretendardBodySemiBold15,
      chevronIsHidden: true
    )
    self.termsAndPoliciesAgreementRow = TermsAgreementViewRow(
      title: Constant.TermsAgreementView.StringLiteral.agreeTermsAndPolicies,
      font: UIFont.pretendardBodyMedium,
      chevronIsHidden: false
    )
    self.privacyPolicyRow = TermsAgreementViewRow(
      title: Constant.TermsAgreementView.StringLiteral.agreePrivacyPolicy,
      font: UIFont.pretendardBodyMedium,
      chevronIsHidden: false
    )
    self.eventAndPromotionalInformationRow = TermsAgreementViewRow(
      title: Constant.TermsAgreementView.StringLiteral.agreeEventAndPromotionalInformation,
      font: UIFont.pretendardBodyMedium,
      chevronIsHidden: false
    )
    self.doneButton = ToDoGardenBoxButton(
      title: Constant.TermsAgreementView.StringLiteral.done,
      buttonType: ToDoGardenBoxButton.Configuration.smallRoundRectButton
    )
    super.init(frame: CGRect.zero)
    self.setupViews()
    self.setupDelegateActions()
  }
  // swiftlint:enable function_body_length
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  override public var intrinsicContentSize: CGSize {
    return Constant.TermsAgreementView.Layout.size
  }
  
  private func setupDelegateActions() {
    self.termsAndPoliciesAgreementRow.chevronAction = { [weak self] in
      guard let self = self else { return }
      self.delegate?.termsAgreementView(self, didTapTermsAndPoliciesAgreement: ())
    }
    
    self.privacyPolicyRow.chevronAction = { [weak self] in
      guard let self = self else { return }
      self.delegate?.termsAgreementView(self, didTapPrivacyPolicy: ())
    }
    
    self.eventAndPromotionalInformationRow.chevronAction = { [weak self] in
      guard let self = self else { return }
      self.delegate?.termsAgreementView(self, didTapEventAndPromotionalInformation: ())
    }
    
    self.doneButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      let isEventAndPromotionalInformationAgreed = self.eventAndPromotionalInformationRow.isSelected
      self.delegate?.termsAgreementView(self, didTapDoneButton: isEventAndPromotionalInformationAgreed)
    }, for: .touchUpInside)
  }
}

// MARK: - UI Setup
extension TermsAgreementView {
  private func setupViews() {
    self.backgroundColor = .white
    self.setupCornerRadius()
    self.setupTitle()
    self.setupParentRowRow()
    self.setupChildRowsInStackView()
    self.setupDoneButton()
    self.setupCheckBoxCondition()
  }
  
  private func setupCornerRadius() {
    self.layer.cornerRadius = Constant.TermsAgreementView.Layout.cornerRadius
    self.clipsToBounds = true
  }
  
  private func setupTitle() {
    let titleLabel = UILabel()
    let titleText = Constant.TermsAgreementView.StringLiteral.termsAgreement
    titleLabel.attributedText = titleText.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    self.addSubview(titleLabel)
    titleLabel.usingAutolayout()
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.topAnchor.constraint(
        equalTo: self.topAnchor,
        constant: Constant.TermsAgreementView.Layout.titleTopMargin
      )
    ])
  }
  
  private func setupParentRowRow() {
    self.addSubview(self.agreeToAllRow)
    self.agreeToAllRow.usingAutolayout()
    NSLayoutConstraint.activate([
      self.agreeToAllRow.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: Constant.TermsAgreementView.Rows.Layout.headLeadingMargin
      ),
      self.agreeToAllRow.topAnchor.constraint(
        equalTo: self.topAnchor,
        constant: Constant.TermsAgreementView.Rows.Layout.headTopMargin
      )
    ])
  }
  
  private func setupChildRowsInStackView() {
    let arrangedRows = [
      self.termsAndPoliciesAgreementRow,
      self.privacyPolicyRow,
      self.eventAndPromotionalInformationRow
    ]
    
    let stackView = UIStackView(arrangedSubviews: arrangedRows)
    stackView.axis = NSLayoutConstraint.Axis.vertical
    
    self.addSubview(stackView)
    stackView.usingAutolayout()
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(
        equalTo: self.agreeToAllRow.leadingAnchor,
        constant: Constant.TermsAgreementView.Rows.Layout.stackViewLeadingMargin
      ),
      stackView.topAnchor.constraint(equalTo: self.agreeToAllRow.bottomAnchor)
    ])
  }
  
  private func setupDoneButton() {
    let constant = Constant.TermsAgreementView.DoneButton.Layout.self
    self.addSubview(self.doneButton)
    self.doneButton.disable()
    self.doneButton.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant.bottomMargin)
    ])
  }
}

// MARK: - Checkbox Logic

extension TermsAgreementView {
  
  private func setupCheckBoxCondition() {
    self.agreeToAllRow.checkButton.addAction(
      UIAction { [weak self] _ in self?.agreeToAllTapped() },
      for: UIControl.Event.touchUpInside
    )
    self.termsAndPoliciesAgreementRow.checkButton.addAction(
      UIAction { [weak self] _ in self?.rowTapped() },
      for: UIControl.Event.touchUpInside
    )
    self.privacyPolicyRow.checkButton.addAction(
      UIAction { [weak self] _ in self?.rowTapped() },
      for: UIControl.Event.touchUpInside
    )
    self.eventAndPromotionalInformationRow.checkButton.addAction(
      UIAction { [weak self] _ in self?.rowTapped() },
      for: UIControl.Event.touchUpInside
    )
  }
  
  private func agreeToAllTapped() {
    let isSelected = self.agreeToAllRow.isSelected
    self.termsAndPoliciesAgreementRow.isSelected = isSelected
    self.privacyPolicyRow.isSelected = isSelected
    self.eventAndPromotionalInformationRow.isSelected = isSelected
    self.updateDoneButtonState()
  }
  
  private func rowTapped() {
    self.updateAgreeToAllState()
    self.updateDoneButtonState()
  }
  
  private func updateAgreeToAllState() {
    let allSelected = self.termsAndPoliciesAgreementRow.isSelected &&
    self.privacyPolicyRow.isSelected &&
    self.eventAndPromotionalInformationRow.isSelected
    self.agreeToAllRow.isSelected = allSelected
  }
  
  private func updateDoneButtonState() {
    let mandatorySelected = self.termsAndPoliciesAgreementRow.isSelected && self.privacyPolicyRow.isSelected
    self.doneButton.isEnabled = mandatorySelected
  }
}

// MARK: - Preview

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = UIView(frame: .infinite)
  view.backgroundColor = .gray
  
  let termsAgreementView = TermsAgreementView()
  view.addSubview(termsAgreementView)
  termsAgreementView.usingAutolayout()
  
  NSLayoutConstraint.activate([
    termsAgreementView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    termsAgreementView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
  ])
  
  return view
}
#endif
