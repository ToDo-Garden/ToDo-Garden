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
