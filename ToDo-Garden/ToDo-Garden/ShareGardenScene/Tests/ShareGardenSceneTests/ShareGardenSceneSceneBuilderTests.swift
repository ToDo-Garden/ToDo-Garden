//
//  ShareGardenSceneSceneBuilderTests.swift
//  ShareGardenScene
//
//  Created by Noah on 10/15/24.
//

import Testing

@testable import ShareGardenScene

@MainActor
struct ShareGardenSceneSceneBuilderTests {
  private let sut: ShareGardenSceneSceneBuilder
  
  init() {
    self.sut = ShareGardenSceneSceneBuilder(dependency: .preview)
  }
  
  @Test
  private func buildTest() throws {
    // When
    let builderResult = self.sut.build()
    
    // Then
    let shareGardenScene = try #require(builderResult as? ShareGardenSceneViewController)
    let interactor = try #require(shareGardenScene.interactor as? ShareGardenSceneInteractor)
    _ = try #require(interactor.presenter as? ShareGardenScenePresenter)
    _ = try #require(shareGardenScene.router as? ShareGardenSceneRouter)
  }
}
