//
//  SearchGardenWorkable.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneEntity

public protocol SearchGardenWorkable {
  func fetchUserDataForAddingGarden(userID: String) async -> SearchGarden.FetchedUserDataForAddingGarden
}
