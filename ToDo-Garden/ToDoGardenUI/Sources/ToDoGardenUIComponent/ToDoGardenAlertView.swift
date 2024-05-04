//
//  ToDoGardenAlertView.swift
//
//
//  Created by SONG on 5/4/24.
//

import UIKit

import ToDoGardenUIConstant

final public class ToDoGardenAlertView: UIView {
  private var configuration: Configuration
  
  init(configuration: Configuration) {
    self.configuration = configuration
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: self.configuration.contents.backPlane.width,
      height: self.configuration.contents.backPlane.height
    )
  }
  
  private func build() {
    // MARK: - BackgroundColor
    self.backgroundColor = UIColor.toDoGardenWhite
    
    // MARK: - CornerRadius
    self.layer.cornerRadius = self.configuration.contents.backPlane.cornerRadius
    
    // MARK: - Title
    self.buildTitleLabel()
    
    // MARK: - Description
    self.buildDescription()
    
    // MARK: - StackView
    self.buildStackView()
  }
}

extension ToDoGardenAlertView {
  private func buildTitleLabel() {
    
  }
  
  private func buildDescription() {
    
  }
  
  private func buildStackView() {
    
  }
}

extension ToDoGardenAlertView {
  public struct Configuration {
    let contents: Constant.ToDoGardenAlertView.Content.ViewState
    
    public init(
      contents: Constant.ToDoGardenAlertView.Content.ViewState
    ) {
      self.contents = contents
    }
  }
}
