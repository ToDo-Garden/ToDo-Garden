//
//  DateRangeCollectionViewCell.swift
//
//
//  Created by SONG on 8/6/24.
//

import UIKit

final class DateRangeCollectionViewCell: CalendarCollectionViewCell {
  override var isSelected: Bool {
    willSet {
      if newValue {
        self.selectWingViews()
      } else {
        self.deSelectWingViews()
      }
    }
  }
  
  var selectionType: SelectionType = SelectionType.none {
    didSet {
      self.updateSelectionAppearance()
    }
  }
  
  private let rightWingView: UIView
  private let leftWingView: UIView
  
  override init(frame: CGRect) {
    self.rightWingView = UIView()
    self.leftWingView = UIView()
    super.init(frame: frame)
    self.setupRightWing()
    self.setupLeftWing()
    self.bringSubviewToFront(self.dayLabel)
  }
  
  private func selectWingViews() {
    self.rightWingView.backgroundColor = UIColor.toDoGardenGreenDark
    self.leftWingView.backgroundColor = UIColor.toDoGardenGreenDark
  }
  
  private func deSelectWingViews() {
    self.rightWingView.backgroundColor = UIColor.clear
    self.leftWingView.backgroundColor = UIColor.clear
  }
  
  private func setupRightWing() {
    self.rightWingView.backgroundColor = UIColor.clear
    self.contentView.addSubview(self.rightWingView)
    self.rightWingView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.rightWingView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        self.rightWingView.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        self.rightWingView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        self.rightWingView.widthAnchor.constraint(equalToConstant: 15.0 + 7.5)
      ]
    )
  }
  
  private func setupLeftWing() {
    self.leftWingView.backgroundColor = UIColor.clear
    self.contentView.addSubview(self.leftWingView)
    self.leftWingView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.leftWingView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        self.leftWingView.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        self.leftWingView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        self.leftWingView.widthAnchor.constraint(equalToConstant: 15.0 + 7.5)
      ]
    )
  }
}

extension DateRangeCollectionViewCell {
  
  func updateSelectionAppearance() {
    switch selectionType {
    case SelectionType.none:
      super.isSelected = false
      self.deSelectWingViews()
    case SelectionType.full:
      super.isSelected = true
      self.selectWingViews()
    case SelectionType.left:
      super.isSelected = true
      self.selectLeftWingView()
    case SelectionType.right:
      super.isSelected = true
      self.selectRightWingView()
    case SelectionType.single:
      super.isSelected = true
      self.deSelectWingViews()
    }
  }
  
  private func selectLeftWingView() {
    self.leftWingView.backgroundColor = UIColor.toDoGardenGreenDark
    self.rightWingView.backgroundColor = UIColor.clear
  }
  
  private func selectRightWingView() {
    self.rightWingView.backgroundColor = UIColor.toDoGardenGreenDark
    self.leftWingView.backgroundColor = UIColor.clear
  }
}
