//
//  TermsAgreementViewRow.swift
//
//
//  Created by SONG on 9/22/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class TermsAgreementViewRow: UIView {
  // MARK: - Properties
  let checkButton: UIButton
  private let textLabel: UILabel
  private let chevronButton: UIButton
  
  var isSelected: Bool {
    get { return self.checkButton.isSelected }
    set { self.checkButton.isSelected = newValue }
  }
  
  var chevronAction: (() -> Void)?
  
  override public var intrinsicContentSize: CGSize {
    return Constant.TermsAgreementViewRow.Layout.size
  }
  
  // MARK: - Initialization
  init(chevronButtonIsHidden: Bool) {
    self.checkButton = UIButton(type: UIButton.ButtonType.custom)
    self.textLabel = UILabel()
    self.chevronButton = UIButton(type: UIButton.ButtonType.system)
    
    super.init(frame: CGRect.zero)
    self.setupViews()
    self.chevronButton.isHidden = chevronButtonIsHidden
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - UISetup
  private func setupViews() {
  }
}
