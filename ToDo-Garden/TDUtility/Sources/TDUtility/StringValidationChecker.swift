//
//  File.swift
//
//
//  Created by SONG on 10/14/24.
//

import Foundation

public final class StringValidationChecker {
  public static func isValidID( _ string : String) -> Bool {
    let regexPattern = "^[\\p{L}\\p{N}]{5,12}$"
    let result = string.range(of: regexPattern, options: String.CompareOptions.regularExpression)
    return result != nil
  }
}
