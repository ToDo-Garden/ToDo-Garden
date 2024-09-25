//
//  Constant+TermsAgreementView.swift
//  
//
//  Created by SONG on 9/25/24.
//

import Foundation

extension Constant.TermsAgreementView {
  public enum StringLiteral {
    public static let termsAgreement: String = "약관동의"
    public static let done: String = "완료"
    public static let agreeAll: String = "전체 동의"
    public static let agreeTermsAndPolicies: String = "약관 및 정책 동의"
    public static let agreePrivacyPolicy: String = "개인정보 처리 방침"
    public static let agreeEventAndPromotionalInformation: String = "이벤트, 광고성 정보 안내 (선택)"
  }
  
  public enum Layout {
    public static let size: CGSize = CGSize(width: 273.0, height: 251.0)
    public static let cornerRadius: CGFloat = 20.0
    public static let titleTopMargin: CGFloat = 21.0
  }
  
  public enum Rows { }
  public enum DoneButton { }
}

extension Constant.TermsAgreementView.Rows {
  public enum Layout {
    public static let headLeadingMargin: CGFloat = 23.0
    public static let headTopMargin: CGFloat = 56.0
    public static let stackViewLeadingMargin: CGFloat = 9.0
  }
}

extension Constant.TermsAgreementView.DoneButton {
  public enum Layout {
    public static let cornerRadius: CGFloat = 18.66
    public static let bottomMargin: CGFloat = -21.0
    public static let width: CGFloat = 230.0
    public static let height: CGFloat = 37.0
  }
}
