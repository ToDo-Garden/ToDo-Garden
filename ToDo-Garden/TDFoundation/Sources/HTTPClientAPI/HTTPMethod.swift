//
//  HTTPMethod.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

public enum HTTPMethod: String, Sendable, Codable {
  case post = "POST"
  case get = "GET"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}
