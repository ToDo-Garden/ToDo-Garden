//
//  AppleLoginBottomSheetViewController.swift
//
//
//  Created by SONG on 10/3/24.
//

import UIKit

final class AppleLoginBottomSheetViewController: UIViewController {
  weak var delegate: AppleLoginBottomSheetDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.delegate?.bottomSheetWillDisappear()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.delegate?.bottomSheetWillAppear()
  }
}
