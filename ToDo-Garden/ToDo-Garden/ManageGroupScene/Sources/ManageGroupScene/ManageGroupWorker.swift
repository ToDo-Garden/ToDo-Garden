//
//  ReorderGroupWorker.swift
//
//
//  Created by SONG on 8/1/24.
//

import UIKit

import HTTPClientAPI
import ManageGroupSceneAPI
import ManageGroupSceneEntity
import TDFoundation
import TDUtility

public class ManageGroupWorker: ManageGroupWorkable {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func fetchGroupList(
    request: ManageGroupSceneEntity.ManageGroup.FetchGroupList.Request
  ) async throws -> [ManageGroup.ToDoGroup] {
    do {
      let groups = try await self.fetchGroupsFromDatabase()
      return groups
    } catch let error {
      throw error
    }
  }
  
  public func saveGroupList(
    request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request
  ) async throws -> [ManageGroup.ToDoGroup] {
    do {
      let groups = try await self.saveGroupsInDatabase(groupList: request.list)
      return groups
    } catch let error {
      throw error
    }
  }
  
  public func addGroup(request: ManageGroup.AddGroup.Request) -> ManageGroup.ToDoGroup {
    let group = ManageGroup.ToDoGroup(
      groupID: request.groupID,
      groupName: request.groupName,
      progressColor: request.groupColor,
      progressRate: Float.zero
    )
    return group
  }
  
  public func editGroup(
    request: ManageGroup.EditGroup.Request,
    progressRate: Float
  ) -> ManageGroup.ToDoGroup {
    let group = ManageGroup.ToDoGroup(
      groupID: request.groupID,
      groupName: request.groupName,
      progressColor: request.groupColor,
      progressRate: progressRate
    )
    return group
  }
  
  public func addGroupDirectly(request: ManageGroup.AddGroup.Request) async throws -> UUID {
    let groupID = try await self.addGroupDirectlyInDatabase(request: request)
    return groupID
  }
  
  private func saveGroupsInDatabase(groupList: [ManageGroup.ToDoGroup]) async throws -> [ManageGroup.ToDoGroup] {
    return groupList
  }
  // swiftlint: disable all
  private func fetchGroupsFromDatabase() async throws -> [ManageGroup.ToDoGroup] {
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
          let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    let fetchedData = try await self.httpClient.send(
      input: ManageGroup.FetchGroupList.RequestDTO(),
      serializer: { data in
        return HTTPRequest(
          method: .get,
          endPoint: URLConstants.Group.fetchGroups,
          header: [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessTokenString)",
            "Accept-Profile": "todogarden"
          ]
        )
      },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let body = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        return try JSONDecoder().decode(ManageGroup.FetchGroupList.ResponseDTO.self, from: body)
      }
    )
    
    var groups: [ManageGroup.ToDoGroup] = []
    for item in fetchedData.data {
      guard let groupID = UUID(uuidString: item.id) else {
        throw NSError(domain: "Invalid GroupID", code: 0)
      }
      
      groups.append(
        ManageGroup.ToDoGroup(
          groupID: groupID,
          groupName: item.name,
          progressColor: try UIColor().fromHex(item.color),
          progressRate: Float(item.progressrate)
        )
      )
    }
    
    return groups
  }
  
  private func addGroupDirectlyInDatabase(request: ManageGroup.AddGroup.Request) async throws -> UUID {
    guard let accessToken = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
          let accessTokenString = String(data: accessToken, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    guard let groupID = try await self.httpClient.send(
      input: ManageGroup.AddGroup.RequestDTO(
        name: request.groupName,
        color: request.groupColor.hexStringFromColor()
      ),
      serializer: { data in
        return HTTPRequest(
          method: .post,
          endPoint: URLConstants.Group.addGroup,
          header: [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessTokenString)",
            "Accept-Profile": "todogarden"
          ],
          body: try JSONEncoder().encode(data)
        )
      },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let body = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        guard let uuidString = String(data: body, encoding: .utf8),
          let uuid = UUID(uuidString: uuidString.trimmingCharacters(in: .init(charactersIn: "\""))) else {
          throw HTTPClientError.deserializationError
        }
        
        return uuid
      }
    ) else { throw NSError(domain: "Invalid GroupID", code: 0) }
    
    return groupID
  }
}
// swiftlint: enable all
