//
//  PostGroupWorker.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import PostGroupSceneAPI

public struct PostGroupWorker: PostGroupWorkable {
  public init() {}
  
  public func changeColor(groupColor: UIColor) {
    // 서버에 hex를 요청 파이어베이스 명세에 따라 로직 변경 가능성 농후
    // self.hexStringFromColor(color)
  }
  
  public func touchDoneButton(groupID: String, groupName: String, groupColor: UIColor) {
    
  }
}

extension PostGroupWorker {
  private func hexStringFromColor(_ color: UIColor) -> String {
    var red: CGFloat = CGFloat.zero
    var green: CGFloat = CGFloat.zero
    var blue: CGFloat = CGFloat.zero
    var alpha: CGFloat = CGFloat.zero
    
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
    
    return String(format: "#%06x", rgb)
  }
}
