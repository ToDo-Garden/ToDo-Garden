//
//  FriendsGardenGardenInfoViewContentConfiguration.swift
//  ShareGardenScene
//
//  Created by Noah on 9/13/24.
//

import UIKit

import ToDoGardenUIComponent

extension ShareGardenSceneViewController {
  struct FriendsGardenContentConfiguration: UIContentConfiguration, Identifiable {
    let id: UUID
    let pomodoroRecords: PomodoroRecordCollection
    
    init(id: UUID, pomodoroRecords: PomodoroRecordCollection) {
      self.id = id
      self.pomodoroRecords = pomodoroRecords
    }
    
    func updated(for state: UIConfigurationState) -> FriendsGardenContentConfiguration {
      return self
    }
    
    func makeContentView() -> UIView & UIContentView {
      return FriendsGardenInfoView(configuration: self)
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenContentConfiguration: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
  static func == (
    lhs: ShareGardenSceneViewController.FriendsGardenContentConfiguration,
    rhs: ShareGardenSceneViewController.FriendsGardenContentConfiguration
  ) -> Bool {
    return lhs.id == rhs.id
  }
}

extension ShareGardenSceneViewController {
  final class FriendsGardenInfoView: UIView & UIContentView {
    var configuration: UIContentConfiguration
    
    private let gardenView = GardenView()
    private static let layoutConstant = ShareGardenSceneViewController.Constant.Layout.FriendsGardenInfoView.self
    
    override var intrinsicContentSize: CGSize {
      return Self.layoutConstant.contentSize
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    init(configuration: FriendsGardenContentConfiguration) {
      self.configuration = configuration
      super.init(frame: CGRect.zero)
      self.setup()
      self.gardenView.configure(with: configuration.pomodoroRecords)
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenInfoView {
  private func setup() {
    self.addSubviews()
    self.setupLayoutConstraints()
    self.setupAppearance()
  }
  
  private func addSubviews() {
    self.addSubview(self.gardenView)
  }
  
  private func setupLayoutConstraints() {
    self.gardenView.usingAutolayout()
    self.gardenView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.gardenView.topAnchor.constraint(
      equalTo: self.topAnchor,
      constant: Self.layoutConstant.gardenViewtopInset
    ).isActive = true
  }
  
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
  }
}
