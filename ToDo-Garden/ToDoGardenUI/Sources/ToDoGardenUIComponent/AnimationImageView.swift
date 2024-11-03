//
//  AnimationImageView.swift
//
//
//  Created by SONG on 10/29/24.
//

import UIKit

import Lottie
import ToDoGardenUIConstant
import ToDoGardenUIResource

private enum AnimationImageViewError: Error {
  case bundleLoadFailed
  case jsonURLNotFound
  case animationLoadFailed
}

public class AnimationImageView: UIView {
  private var animationView: LottieAnimationView
  private var animationTask: Task<Void, Never>?
  
  public init(jsonName: String) {
    self.animationView = LottieAnimationView()
    super.init(frame: .zero)
    self.setupAnimation(jsonName: jsonName)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupAnimation(jsonName: String) {
    self.animationTask = Task {
      defer {
        self.animationTask = nil
      }
      
      do {
        try await self.loadAndSetupAnimation(jsonName: jsonName)
      } catch {
        // TODO: 에러처리 
      }
    }
  }
  
  private func loadAndSetupAnimation(jsonName: String) async throws {
    guard let bundle = Bundle.toDoGardenUIResource else {
      throw AnimationImageViewError.bundleLoadFailed
    }
    
    guard let jsonURL = bundle.url(
      forResource: jsonName,
      withExtension: Constant.AnimationImageView.StringLiteral.fileFormat,
      subdirectory: Constant.AnimationImageView.StringLiteral.subDirectory
    ) else {
      throw AnimationImageViewError.jsonURLNotFound
    }
    
    try await self.loadAnimation(from: jsonURL)
    self.setupAnimationView()
  }
  
  private func loadAnimation(from url: URL) async throws {
    if let animation = await LottieAnimation.loadedFrom(url: url) {
      self.animationView = LottieAnimationView(animation: animation)
    } else {
      throw AnimationImageViewError.animationLoadFailed
    }
  }
  
  private func setupAnimationView() {
    self.animationView.usingAutolayout()
    self.addSubview(self.animationView)
    
    NSLayoutConstraint.activate([
      self.animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.animationView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.animationView.topAnchor.constraint(equalTo: self.topAnchor),
      self.animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    
    self.animationView.contentMode = UIView.ContentMode.scaleAspectFit
    self.animationView.loopMode = LottieLoopMode.loop
    self.startAnimation()
  }
  
  public func startAnimation() {
    self.animationView.play()
  }
  
  public func pauseAnimation() {
    self.animationView.pause()
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = AnimationImageView(jsonName: "LoadingIndicator")
  
  Task {
    try? await Task.sleep(nanoseconds: 3000000000)
    view.pauseAnimation()
  }
  
  Task {
    try? await Task.sleep(nanoseconds: 6000000000)
    view.startAnimation()
  }
  
  return view
}
#endif
