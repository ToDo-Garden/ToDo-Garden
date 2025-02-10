//
//  AllUsersMock.swift
//  SearchGardenScene
//
//  Created by SONG on 2/10/25.
//
// swiftlint:disable all

import UIKit

import ToDoGardenUIComponent

enum AllUsersMock {
  static let allUsers: [SearchGardenUser] =
  [
    SearchGardenUser(id: UUID(), nickname: "Alice", customId: "alice01", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Bob", customId: "bob02", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Charlie", customId: "charlie03", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "David", customId: "david04", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Eve", customId: "eve05", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Frank", customId: "frank06", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Grace", customId: "grace07", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Hank", customId: "hank08", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Ivy", customId: "ivy09", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Jack", customId: "jack10", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Kim", customId: "kim11", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Leo", customId: "leo12", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Mia", customId: "mia13", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Noah", customId: "noah14", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Olivia", customId: "olivia15", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Paul", customId: "paul16", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Quinn", customId: "quinn17", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Ryan", customId: "ryan18", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Sophia", customId: "sophia19", userImage: nil, userImageURL: nil),
    SearchGardenUser(id: UUID(), nickname: "Tom", customId: "tom20", userImage: nil, userImageURL: nil)
  ]
  
  static func filterUsers(by customIdSubstring: String) -> [SearchGardenUser] {
    guard !customIdSubstring.isEmpty else { return self.allUsers }
    return self.allUsers.filter { $0.customId.contains(customIdSubstring) }
  }
  
  static func getRandomUserUUID() -> UUID? {
    return allUsers.randomElement()?.id
  }
  
  static func getUserDetails(by uuid: UUID) -> (nickname: String, customId: String, userImage: UIImage?)? {
    guard let user = allUsers.first(where: { $0.id == uuid }) else { return nil }
    return (user.nickname, user.customId, user.userImage)
  }
}

// swiftlint:enable all
