//
//  HomeSceneDelegate.swift
//  HomeScene
//
//  Created by nathan on 4/2/25.
//

import Foundation

@MainActor
public protocol HomeSceneDelegate: AnyObject {
  func remainToDoCount(_ count: Int)
}
