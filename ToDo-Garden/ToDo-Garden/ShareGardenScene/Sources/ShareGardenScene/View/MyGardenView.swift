//
//  MyGardenView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/13/24.
//

import UIKit

extension ShareGardenSceneViewController {
  final class MyGardenView: UIStackView {
    
    init() {
      super.init(frame: CGRect.zero)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
