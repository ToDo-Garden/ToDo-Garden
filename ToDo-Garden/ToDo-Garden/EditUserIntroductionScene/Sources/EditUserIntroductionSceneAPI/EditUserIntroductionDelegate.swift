//
//  EditUserIntroductionDelegate.swift
//
//
//  Created by Wood on 10/18/24.
//

import Foundation

public protocol EditUserIntroductionDelegate: AnyObject {
  func userIntroductionDidEdited(new introduction: String?)
}
