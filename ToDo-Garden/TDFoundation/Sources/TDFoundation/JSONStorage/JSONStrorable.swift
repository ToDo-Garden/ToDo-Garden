//
//  JSONStrorable.swift
//  TDFoundation
//
//  Created by SONG on 3/21/25.
//

public protocol JSONStorable<Item>: Sendable where Item: Codable {
  associatedtype Item: Codable
  
  func saveItem(_ item: Item) throws
  func saveItems(_ items: [Item]) throws
  func getItems() throws -> [Item]
  func deleteAllItems() throws
  func updateOrAddItem(
    where condition: (Item) -> Bool,
    update: (inout Item) -> Void,
    new: () -> Item
  ) throws
}
