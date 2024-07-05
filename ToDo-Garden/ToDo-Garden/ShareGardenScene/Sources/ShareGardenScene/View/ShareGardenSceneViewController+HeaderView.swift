//
//  ShareGardenSceneViewController+HeaderView.swift
//
//
//  Created by Noah on 7/5/24.
//

import UIKit

import ToDoGardenUIComponent

extension ShareGardenSceneViewController {
  final class HeaderView: UIStackView {
    
    // MARK: - Object life cycle
    
    init() {
      super.init(frame: CGRect.zero)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
