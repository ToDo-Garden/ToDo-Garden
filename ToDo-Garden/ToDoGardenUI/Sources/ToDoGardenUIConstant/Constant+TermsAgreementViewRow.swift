//
//  Constant+TermsAgreementViewRow.swift
//
//
//  Created by SONG on 9/25/24.
//

import Foundation

extension Constant.TermsAgreementViewRow {
  public enum Layout {
    public static let size: CGSize = CGSize(width: 220.0, height: 30.0)
    public static let commonMargin: CGFloat = 7.0
  }
  
  public enum TextLabel { }
  public enum ChevronButton { }
  public enum CheckButton { }
}

extension Constant.TermsAgreementViewRow.TextLabel {
  public static let fontSize: CGFloat = 16.0
  
  public enum Layout {
    public static let width: CGFloat = 165.0
    public static let height: CGFloat = 16.0
  }
}

extension Constant.TermsAgreementViewRow.ChevronButton {
  public enum Layout {
    public static let length: CGFloat = 18.0
  }
}

extension Constant.TermsAgreementViewRow.CheckButton {
  public enum Layout {
    public static let length: CGFloat = 14.0
  }
}
