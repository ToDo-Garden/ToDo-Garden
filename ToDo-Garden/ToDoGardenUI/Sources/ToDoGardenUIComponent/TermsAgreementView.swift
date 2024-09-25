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
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override public var intrinsicContentSize: CGSize {
    return Constant.TermsAgreementView.Layout.size
  }
}
