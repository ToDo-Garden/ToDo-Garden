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

public final class SearchGardenUser {
  public let id: UUID
  public let nickname: String
  public let customId: String
  public var userImage: UIImage?
  public var userImageURL: URL?
  public let isDummyData: Bool

  public init(
    id: UUID,
    nickname: String,
    customId: String,
    userImage: UIImage?,
    userImageURL: URL?,
    isDummyData: Bool = false
  ) {
    self.id = id
    self.nickname = nickname
    self.customId = customId
    self.userImage = userImage
    self.userImageURL = userImageURL
    self.isDummyData = isDummyData
  }
}

extension SearchGardenUser: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
  public static func == (lhs: SearchGardenUser, rhs: SearchGardenUser) -> Bool {
    return lhs.id == rhs.id
  }
  
  public static let placeholderData = SearchGardenUser(
    id: UUID(),
    nickname: "Dummy",
    customId: "@DummyID",
    userImage: nil,
    userImageURL: nil,
    isDummyData: true
  )
}
