//
//  ReorderGroupWorker.swift
//
//
//  Created by SONG on 8/1/24.
//

import Foundation

import ManageGroupSceneAPI
import ManageGroupSceneEntity

public class ManageGroupWorker: ManageGroupWorkable {
  public init() {}
  
  public func fetchGroupList(
    request: ManageGroupSceneEntity.ManageGroup.FetchGroupList.Request
  ) async -> Result<[ManageGroup.ToDoGroup], Error> {
    do {
      let groups = try await fetchGroupsFromDatabase()
      return .success(groups)
    } catch {
      return .failure(error)
    }
  }
  
  public func saveGroupList(
    request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request
  ) async -> Result<[ManageGroupSceneEntity.ManageGroup.ToDoGroup], any Error> {
    do {
      let groups = try await saveGroupsInDatabase(groupList: request.list)
      return .success(groups)
    } catch {
      return .failure(error)
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
  
  public func editGroup(request: ManageGroup.EditGroup.Request, progressRate: Float) -> ManageGroup.ToDoGroup {
    let group = ManageGroup.ToDoGroup(
      groupID: request.groupID,
      groupName: request.groupName,
      progressColor: request.groupColor,
      progressRate: progressRate
    )
    return group
  }

  private func fetchGroupsFromDatabase() async throws -> [ManageGroup.ToDoGroup] {
    let fetchedData: [ManageGroup.ToDoGroup] = ManageGroupMockData.fetchedData
    return fetchedData
  }
  
  private func saveGroupsInDatabase(groupList: [ManageGroup.ToDoGroup]) async throws -> [ManageGroup.ToDoGroup] {
    return groupList
  }
}
