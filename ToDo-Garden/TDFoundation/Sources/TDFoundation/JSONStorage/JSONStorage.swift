//
//  JSONStorage.swift
//  TDFoundation
//
//  Created by SONG on 3/20/25.
//

import Foundation

public enum StorageError: Error {
  case emptyData
  case nonExistentData
}

public final class JSONStorage<T: Codable>: JSONStorable, @unchecked Sendable {
  public typealias Item = T // 요청 DTO단위로 넣어주세요. 빼서 바로 요청을 쏠 수 있도록
  
  private let fileManager: FileManager
  private let documentsURL: URL
  private let fileName: String
  
  private var storageURL: URL {
    return self.documentsURL.appendingPathComponent(self.fileName)
  }
  
  public init(fileName: String) {
    self.fileManager = FileManager.default
    self.fileName = fileName
    
    guard let documentsURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask).first else {
      fatalError("Can not access documents directory.")
    }
    
    self.documentsURL = documentsURL
  }
  
  public func saveItem(_ item: T) throws {
    do {
      var items = try self.loadItemsFromJSON()
      items.append(item)
      try self.saveItemsAsJSON(items)
    } catch StorageError.nonExistentData {
      try self.saveItemsAsJSON([item])
    }
  }
  
  public func saveItems(_ items: [T]) throws {
    try self.saveItemsAsJSON(items)
  }
  
  public func updateOrAddItem(
    where condition: (T) -> Bool,
    update: (inout T) -> Void,
    new: () -> T
  ) throws {
    do {
      var items = try self.loadItemsFromJSON()
      
      if let index = items.firstIndex(where: condition) {
        var item = items[index]
        update(&item)
        items[index] = item
      } else {
        items.append(new())
      }
      
      try self.saveItemsAsJSON(items)
    } catch StorageError.nonExistentData {
      try self.saveItemsAsJSON([new()])
    }
  }
  
  public func getItems() throws -> [T] {
    let items = try self.loadItemsFromJSON()
    if items.isEmpty {
      throw StorageError.emptyData
    }
    return items
  }
  
  public func deleteAllItems() throws {
    try self.saveItemsAsJSON([])
  }
}

// MARK: - Private Methods
extension JSONStorage {
  private func loadItemsFromJSON() throws -> [T] {
    guard self.fileManager.fileExists(atPath: self.storageURL.path) else {
      throw StorageError.nonExistentData
    }
    
    let data = try Data(contentsOf: self.storageURL)
    
    guard !self.isDataEmpty(data) else {
      throw StorageError.emptyData
    }
    
    return try JSONDecoder().decode([T].self, from: data)
  }
  
  private func saveItemsAsJSON(_ items: [T]) throws {
    let data = try JSONEncoder().encode(items)
    try data.write(to: self.storageURL)
  }
  
  private func isDataEmpty(_ data: Data) -> Bool {
    return data.count == 2 // [] 만 있을 경우
  }
}
