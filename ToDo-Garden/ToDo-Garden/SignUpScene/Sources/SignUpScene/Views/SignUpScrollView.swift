//
//  SignUpScrollView.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import TDUtility
import ToDoGardenUIComponent

final class SignUpScrollView: UIScrollView {
  private(set) var currentPageIndex: Int {
    didSet {
      self.didChangePage()
    }
  }
  private var inputViews: [SignUpInputView]
  
  override init(frame: CGRect) {
    self.currentPageIndex = Int.zero
    self.inputViews = []
    super.init(frame: frame)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
