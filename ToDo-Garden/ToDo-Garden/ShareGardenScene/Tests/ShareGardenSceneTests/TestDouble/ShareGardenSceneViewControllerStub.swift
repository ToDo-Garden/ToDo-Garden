//
//  ShareGardenSceneViewControllerStub.swift
//  ShareGardenScene
//
//  Created by Noah on 10/8/24.
//

import Foundation

@testable import ShareGardenScene
import ShareGardenSceneEntity

final class ShareGardenSceneViewControllerStub {
  // MARK: - My Garden 관련 스트림
  let (myGardenStream, myGardenStreamContinuation) = AsyncStream.makeStream(
    of: ShareGardenScene.RequestMyGarden.ViewModel.self,
    bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
  )
  
  let (myGardenRequestErrorStream, myGardenRequestErrorStreamContinuation) = AsyncStream.makeStream(
    of: Void.self,
    bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
  )
  
  // MARK: - Friends Garden 관련 스트림
  let (friendsGardenListStream, friendsGardenListStreamContinuation) = AsyncStream.makeStream(
    of: ShareGardenScene.RequestFriendsGardenList.ViewModel.self,
    bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
  )
  
  let (friendsGardenListRequestErrorStream, friendsGardenListRequestErrorStreamContinuation) = AsyncStream.makeStream(
    of: Void.self,
    bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
  )
  
  // MARK: - Shimmering 관련 스트림
  let (shimmeringStopStream, shimmeringStopStreamContinuation) = AsyncStream.makeStream(
    of: Void.self,
    bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
  )
}
