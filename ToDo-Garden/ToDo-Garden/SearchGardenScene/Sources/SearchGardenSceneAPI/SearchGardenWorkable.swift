//
//  SearchGardenWorkable.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneEntity

public protocol SearchGardenWorkable {
  func loadFriendGarden(userID: UUID) async throws -> SearchGarden.LoadFriendGardenDTO.Response
  
  func addGarden(userID: UUID) async throws
  func loadSearchedGardenList(inputText: String, page: Int) async throws -> SearchGarden.SearchedGardenList
}
