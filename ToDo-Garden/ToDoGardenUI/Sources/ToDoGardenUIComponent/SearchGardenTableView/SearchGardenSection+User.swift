//
//  SearchGardenSection+User.swift
//
//
//  Created by SONG on 11/23/24.
//

import UIKit

enum SearchGardenSection {
  case main
}

public struct SearchGardenUser: Sendable {
  public let userNickname: String
  public let userID: String
  public let userImage: UIImage?

  public init(userNickname: String, userID: String, userImage: UIImage?) {
    self.userNickname = userNickname
    self.userID = userID
    self.userImage = userImage
  }
}

extension SearchGardenUser: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.userID)
  }
}
