//
//  GardenView.swift
//
//
//  Created by Noah on 6/12/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

import TDUtility

public final class GardenView: UIView {
  private let pomodoroRecordCollectionView: PomodoroRecordCollectionView
  @ExecuteOnce private var setupLayoutIfNeeded: (() -> Void)?
  
  public init() {
    self.pomodoroRecordCollectionView = PomodoroRecordCollectionView()
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayoutIfNeeded = {
      self.setupViewAppearance()
      self.setupLayoutConstraints()
    }
  }
  
  public func configure(with pomodoroRecordCollection: PomodoroRecordCollection) {
    let pomodoroDates = pomodoroRecordCollection.pomodoroDates()
    let pomodoroLevels = pomodoroRecordCollection.normalizedPomodoroLevels()
    
    guard let groupedPomodoroRecordCellItems = PomodoroRecordCellItem.groupedPomodoroRecordCellItem(
      pomodoroDates: pomodoroDates,
      pomodoroLevels: pomodoroLevels
    )
    else { return }
    
    self.pomodoroRecordCollectionView.configure(with: groupedPomodoroRecordCellItems)
  }
}

// MARK: - Setup

extension GardenView {
  private func setup() {
    self.addSubviews()
  }
}

extension GardenView {
  private func addSubviews() {
    self.addSubview(self.pomodoroRecordCollectionView)
  }
}

// MARK: - Setup layout constraints

extension GardenView {
  private func setupLayoutConstraints() {
    self.setupPomodoroRecordsCollectionViewLayoutConstraints()
  }
  
  private func setupPomodoroRecordsCollectionViewLayoutConstraints() {
    self.pomodoroRecordCollectionView.usingAutolayout()
    let topMarginFraction: CGFloat = Constant.GardenView.Layout.PomodoroRecordCollectionView.topMarginFraction
    let horizontalMarginFraction: CGFloat =
    Constant.GardenView.Layout.PomodoroRecordCollectionView.horizontalMarginFraction
    let bottomMarginFraction: CGFloat = Constant.GardenView.Layout.PomodoroRecordCollectionView.bottomMarginFraction
    
    NSLayoutConstraint.activate([
      self.pomodoroRecordCollectionView.topAnchor.constraint(
        equalTo: self.topAnchor,
        constant: self.bounds.height * topMarginFraction
      ),
      self.pomodoroRecordCollectionView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: self.bounds.width * horizontalMarginFraction
      ),
      self.pomodoroRecordCollectionView.trailingAnchor.constraint(
        equalTo: self.trailingAnchor,
        constant: -(self.bounds.width * horizontalMarginFraction)
      ),
      self.pomodoroRecordCollectionView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor,
        constant: -(self.bounds.height * bottomMarginFraction)
      )
    ])
  }
}

// MARK: - Setup view appearance

extension GardenView {
  private func setupViewAppearance() {
    self.roundedCorner()
    self.setupBorder()
  }
  
  private func roundedCorner() {
    let cornerRadiusRatio = Constant.GardenView.Layout.cornerRadiusRatio
    self.layer.cornerRadius = self.bounds.width * (cornerRadiusRatio)
    self.clipsToBounds = true
  }
  
  private func setupBorder() {
    self.layer.borderWidth = Constant.GardenView.Layout.borderWidth
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
  }
}
