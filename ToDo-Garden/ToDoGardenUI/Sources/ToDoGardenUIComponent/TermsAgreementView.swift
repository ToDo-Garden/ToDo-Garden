//
//  TermsAgreementView.swift
//
//  Created by SONG on 9/23/24.
//

import UIKit

import ToDoGardenUIConstant

public final class TermsAgreementView: UIView {
  // MARK: - Properties
  private let agreeToAllRow: TermsAgreementViewRow
  private let termsAndPoliciesAgreementRow: TermsAgreementViewRow
  private let privacyPolicyRow: TermsAgreementViewRow
  private let eventAndPromotionalInformationRow: TermsAgreementViewRow
  
  private let doneButton: ToDoGardenBoxButton
  private var doneButtonCompletion: ((Bool) -> Void)?
  
  // MARK: - Initialization
  public init() {
    self.agreeToAllRow = TermsAgreementViewRow(chevronButtonIsHidden: true)
    self.termsAndPoliciesAgreementRow = TermsAgreementViewRow(chevronButtonIsHidden: false)
    self.privacyPolicyRow = TermsAgreementViewRow(chevronButtonIsHidden: false)
    self.eventAndPromotionalInformationRow = TermsAgreementViewRow(chevronButtonIsHidden: false)
    self.doneButton = ToDoGardenBoxButton(
      title: Constant.TermsAgreementView.StringLiteral.done,
      buttonType: ToDoGardenBoxButton.Configuration.tertiaryRoundRectButton
    )
    
    super.init(frame: CGRect.zero)
    self.setupViews()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override public var intrinsicContentSize: CGSize {
    return Constant.TermsAgreementView.Layout.size
  }
}
extension TermsAgreementView {
  
  private func setupViews() {
    self.backgroundColor = .white
    self.setupCornerRadius()
    self.setupTitle()
    self.setupHeadRow()
    self.setupBodyRows()
    self.setupBodyRowsInStackView()
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
  
  private func setupHeadRow() {
    self.agreeToAllRow.configureTitle(
      with: Constant.TermsAgreementView.StringLiteral.agreeAll,
      isBold: true
    )
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
  
  private func setupBodyRows() {
    let constant = Constant.TermsAgreementView.StringLiteral.self
    self.termsAndPoliciesAgreementRow.configureTitle(
      with: constant.agreeTermsAndPolicies
    )
    self.privacyPolicyRow.configureTitle(
      with: constant.agreePrivacyPolicy
    )
    self.eventAndPromotionalInformationRow.configureTitle(
      with: constant.agreeEventAndPromotionalInformation
    )
  }
  
  private func setupBodyRowsInStackView() {
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
    
    self.doneButton.layer.cornerRadius = constant.cornerRadius
    NSLayoutConstraint.activate([
      self.doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant.bottomMargin),
      self.doneButton.widthAnchor.constraint(equalToConstant: constant.width),
      self.doneButton.heightAnchor.constraint(equalToConstant: constant.height)
    ])
  }
}
