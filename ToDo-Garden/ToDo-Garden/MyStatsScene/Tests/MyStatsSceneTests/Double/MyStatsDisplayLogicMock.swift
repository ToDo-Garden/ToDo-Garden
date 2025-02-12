//
//  MyStatsDisplayLogicMock.swift
//  MyStatsScene
//
//  Created by SONG on 11/29/24.
//

import Foundation

@testable import MyStatsScene
import MyStatsSceneAPI
import MyStatsSceneEntity

final class MyStatsDisplayLogicMock: MyStatsDisplayLogic {
  var result: MyStatsSceneEntity.MyStats.LoadMyStatsViewData.ViewModel?
  
  func displayMyStatsView(viewModel: MyStatsSceneEntity.MyStats.LoadMyStatsViewData.ViewModel) {
    self.result = viewModel
  }
}
