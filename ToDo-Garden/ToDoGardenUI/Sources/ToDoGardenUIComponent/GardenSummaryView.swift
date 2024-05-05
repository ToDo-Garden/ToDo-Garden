//
//  GardenSummaryView.swift
//
//
//  Created by SONG on 5/5/24.
//

import UIKit

import ToDoGardenUIConstant

public final class GardenSummaryView: UIView {
  private let configuration: Configuration
  
  public init(configuration: Configuration) {
    self.configuration = configuration
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func build() {
    // MARK: - BackgroundColor
    self.backgroundColor = UIColor.toDoGardenWhite
    
    // MARK: - layer
    self.setupLayer()
    
    // MARK: - StackView
    self.buildStackView()
    
    // MARK: - Divider
    self.buildDivider()
    
    // MARK: - Descriptions
    self.buildDescriptions()
  }
}

extension GardenSummaryView {
  private func setupLayer() {
    self.layer.cornerRadius = self.configuration.contents.backPlane.cornerRadius
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.layer.borderWidth = self.configuration.contents.backPlane.borderWidth
  }
  
  private func buildStackView() {
    
  }
  
  private func buildDivider() {
    
  }
  
  private func buildDescriptions() {
    
  }
}

extension GardenSummaryView {
  public struct Configuration {
    let contents: Constant.GardenSummaryView.ViewState
    
    public init(
      contents: Constant.GardenSummaryView.ViewState
    ) {
      self.contents = contents
    }
  }
}
