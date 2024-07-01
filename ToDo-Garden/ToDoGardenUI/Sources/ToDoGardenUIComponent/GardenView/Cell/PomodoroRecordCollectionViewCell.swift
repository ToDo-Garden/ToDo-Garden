//
//  PomodoroRecordCollectionViewCell.swift
//
//
//  Created by Noah on 6/7/24.
//

import UIKit

import ToDoGardenUIResource

final class PomodoroRecordCollectionViewCell: UICollectionViewCell {
  private let firstDayOfMonthLabel: UILabel = {
    let firstDayOfMonthLabel = UILabel()
    firstDayOfMonthLabel.font = UIFont.pretendardDetailRegular5
    firstDayOfMonthLabel.textColor = UIColor.black
    firstDayOfMonthLabel.textAlignment = NSTextAlignment.center
    
    return firstDayOfMonthLabel
  }()
  
  private let pomodoroLevelsView: PomodoroLevelCollectionView = {
    let pomodoroLevelsView = PomodoroLevelCollectionView()
    pomodoroLevelsView.showsHorizontalScrollIndicator = false
    pomodoroLevelsView.showsVerticalScrollIndicator = false
    pomodoroLevelsView.isScrollEnabled = false
    
    return pomodoroLevelsView
  }()
  
  private let contentStackView: UIStackView = {
    let contentStackView = UIStackView()
    contentStackView.axis = NSLayoutConstraint.Axis.vertical
    contentStackView.distribution = UIStackView.Distribution.fill
    contentStackView.alignment = UIStackView.Alignment.fill
    contentStackView.spacing = 1
    
    return contentStackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with pomodoroRecordCellItem: PomodoroRecordCellItem) {
    self.pomodoroLevelsView.configure(with: pomodoroRecordCellItem.pomodoroLevels)
    self.configureMonthLabel(with: pomodoroRecordCellItem)
  }
}

// MARK: - Setup

extension PomodoroRecordCollectionViewCell {
  private func setup() {
    self.addSubviews()
    self.setupLayoutConstraints()
  }
}

// MARK: - Add subviews

extension PomodoroRecordCollectionViewCell {
  private func addSubviews() {
    self.contentView.addSubview(self.contentStackView)
    self.contentStackView.addArrangedSubview(self.pomodoroLevelsView)
    self.contentStackView.addArrangedSubview(self.firstDayOfMonthLabel)
  }
}

// MARK: - Setup layout constraints

extension PomodoroRecordCollectionViewCell {
  private func setupLayoutConstraints() {
    self.setupContentsStackViewLayoutConstraints()
  }
  
  private func setupContentsStackViewLayoutConstraints() {
    self.contentStackView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.contentStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.contentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.contentStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
      self.contentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
    ])
  }
}

// MARK: - configure month label

extension PomodoroRecordCollectionViewCell {
  private func configureMonthLabel(with pomodoroRecordCellItem: PomodoroRecordCellItem) {
    guard let firstDayOfMonth = pomodoroRecordCellItem.formattedFirstDayOfMonth()
    else {
      self.firstDayOfMonthLabel.text = " "
      return
    }
    
    self.firstDayOfMonthLabel.text = firstDayOfMonth
  }
}
