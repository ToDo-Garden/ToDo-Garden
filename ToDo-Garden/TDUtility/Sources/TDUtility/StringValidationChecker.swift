//
//  StringValidationChecker.swift
//
//
//  Created by SONG on 10/14/24.
//

import Foundation

public final class StringValidationChecker {
  public static func isValidNickName(_ string: String) -> Bool {
    let regexPattern = "^[\\p{L}\\p{N}]{5,12}$"
    let result = string.range(of: regexPattern, options: String.CompareOptions.regularExpression)
    return result != nil
  }
  
  public static func isValidIntroduction(_ string: String) -> Bool {
    return string.count <= 15
  }
  
  public static func isValidID(_ string: String) -> Bool {
    let regexPattern = "^[a-zA-Z0-9]{5,12}$"
    let result = string.range(of: regexPattern, options: String.CompareOptions.regularExpression)
    return result != nil
  }
}
