//
//  PostGroupWorker.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import PostGroupSceneAPI
import PostGroupSceneEntity

public struct PostGroupWorker: PostGroupWorkable {
  public init() {}
  
  public func touchDoneButton(groupID: UUID?, groupName: String, groupColor: UIColor) -> PostGroup.ToDoGroup {
    // 서버에 그룹 변경을 요청
    // groupID가 nil 경우, 그룹추가하기
    // groupID가 not nil 경우, 그룹편집하기
    let group = PostGroup.ToDoGroup(groupID: groupID, groupName: groupName, groupColor: groupColor)
    return group
  }
}

extension PostGroupWorker {
  private func hexStringFromColor(_ color: UIColor) -> String {
    let multiplier: CGFloat = 255.0
    let redShift: Int = 16
    let greenShift: Int = 8
    
    var red: CGFloat = CGFloat.zero
    var green: CGFloat = CGFloat.zero
    var blue: CGFloat = CGFloat.zero
    var alpha: CGFloat = CGFloat.zero
    
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let rgb: Int = (Int(red * multiplier) << redShift) |
    (Int(green * multiplier) << greenShift) |
    (Int(blue * multiplier))
    
    return String(format: "#%06x", rgb)
  }
}
