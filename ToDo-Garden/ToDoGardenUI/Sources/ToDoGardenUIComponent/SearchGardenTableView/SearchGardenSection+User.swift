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
  public let id: UUID
  public let nickname: String
  public let customId: String
  public let userImage: UIImage?

  public init(id: UUID, nickname: String, customId: String, userImage: UIImage?) {
    self.id = id
    self.nickname = nickname
    self.customId = customId
    self.userImage = userImage
  }
}

extension SearchGardenUser: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
  public static func == (lhs: SearchGardenUser, rhs: SearchGardenUser) -> Bool {
    return lhs.id == rhs.id
  }
}
