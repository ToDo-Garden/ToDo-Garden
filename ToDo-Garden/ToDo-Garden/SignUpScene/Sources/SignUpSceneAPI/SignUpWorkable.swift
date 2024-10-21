//
//  SignUpWorkable.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneEntity

public protocol SignUpWorkable {
  func checkStringValidation(text: String?, currentPageIndex: Int) -> SignUp.ValidationState
}
