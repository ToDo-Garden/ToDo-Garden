//
//  AnimationImageView.swift
//
//
//  Created by SONG on 10/29/24.
//

import UIKit

import Lottie
import ToDoGardenUIResource

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
      
      guard let bundle = Bundle.toDoGardenUIResource else {
        // Bundle load 실패
        return
      }
      
      guard let jsonURL = bundle.url(
        forResource: jsonName,
        withExtension: "json",
        subdirectory: "LottieJsons"
      ) else {
        // JSON URL을 찾지 못함
        return
      }
      
      await self.loadAnimation(from: jsonURL)
      self.setupAnimationView()
    }
  }
  
  private func loadAnimation(from url: URL) async {
    if let animation = await LottieAnimation.loadedFrom(url: url) {
      self.animationView = LottieAnimationView(animation: animation)
    } else {
      // Animation load 실패
      return
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
