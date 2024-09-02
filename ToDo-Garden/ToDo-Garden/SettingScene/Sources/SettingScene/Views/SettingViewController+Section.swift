//
//  SettingViewController+Section.swift
//
//
//  Created by Wood on 8/22/24.
//

import UIKit

import ToDoGardenUIComponent

extension SettingViewController {
  struct Section: Hashable {
    let image: UIImage
    let title: String
    let items: [Item]
  }

  struct Item: Hashable {
    let title: String
    let isShowingModal: Bool
    let position: SettingCollectionViewCell.Position
  }
}
