//
//  DateRangePickerHeaderView.swift
//  ToDoGardenUI
//
//  Created by SONG on 1/31/25.
//

import UIKit

import ToDoGardenUIResource

final class DateRangePickerHeaderView: UIView {
  private let startDateLabel: UILabel
  private let endDateLabel: UILabel
  
  init() {
    self.startDateLabel = UILabel(frame: CGRect.zero)
    self.endDateLabel = UILabel(frame: CGRect.zero)
    super.init(frame: .zero)
    self.backgroundColor = UIColor.white
    self.build()
  }
  
  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 336.0, height: 68.0)
  }
  
  func updateStartDate(to date: String) {
    self.startDateLabel.text = date
  }
  
  func updateEndDate(to date: String) {
    self.endDateLabel.text = date
  }
  
  func clearDates() {
    self.startDateLabel.text = ""
    self.endDateLabel.text = ""
  }
}

extension DateRangePickerHeaderView {
  private func build() {
    self.buildBorderLine()
    self.buildVerticalLine()
    self.setupLabels()
  }
  
  private func buildBorderLine() {
    self.buildHorizontalLine()
  }
  
  private func buildHorizontalLine() {
    let horizontalLine = UIView()
    horizontalLine.backgroundColor = UIColor.toDoGardenGreenGray
    
    self.addSubview(horizontalLine)
    horizontalLine.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        horizontalLine.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        horizontalLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        horizontalLine.heightAnchor.constraint(equalToConstant: 46.0),
        horizontalLine.widthAnchor.constraint(equalToConstant: 2.0)
      ]
    )
  }
  
  private func buildVerticalLine() {
    let verticalLine = UIView()
    verticalLine.backgroundColor = UIColor.toDoGardenGreenGray
    
    self.addSubview(verticalLine)
    verticalLine.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        verticalLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        verticalLine.centerYAnchor.constraint(equalTo: self.bottomAnchor),
        verticalLine.heightAnchor.constraint(equalToConstant: 2.0),
        verticalLine.widthAnchor.constraint(equalToConstant: 336.0)
      ]
    )
  }
}

extension DateRangePickerHeaderView {
  private func setupLabels() {
    self.setupTitleLabels()
    
  }
  
  private func setupTitleLabels() {
    self.setupStartTitleLabel()
    self.setupEndTitleLabel()
    self.setupStartDateLabel()
    self.setupEndDateLabel()
  }
  
  private func setupStartTitleLabel() {
    let startTitle = UILabel()
    startTitle.attributedText = self.setAttributedTitleLight12(with: "시작")
    self.addSubview(startTitle)
    
    startTitle.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        startTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 23.0),
        startTitle.topAnchor.constraint(equalTo: self.topAnchor)
      ]
    )
  }
  
  private func setupEndTitleLabel() {
    let endTitle = UILabel()
    endTitle.attributedText = self.setAttributedTitleLight12(with: "종료")
    self.addSubview(endTitle)
    
    endTitle.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        endTitle.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 23.0),
        endTitle.topAnchor.constraint(equalTo: self.topAnchor)
      ]
    )
  }
  
  private func setupStartDateLabel() {
    self.startDateLabel.attributedText = self.setAttributedTitleBold18(with: "0000. 00. 00")
    self.addSubview(self.startDateLabel)
    
    self.startDateLabel.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.startDateLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -24.0),
        self.startDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.5)
      ]
    )
  }
  
  private func setupEndDateLabel() {
    self.endDateLabel.attributedText = self.setAttributedTitleBold18(with: "0000. 00. 00")
    self.addSubview(self.endDateLabel)
    
    self.endDateLabel.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.endDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
        self.endDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.5)
      ]
    )
  }
  
  private func setAttributedTitleBold18(with title: String) -> NSAttributedString {
    let attributedString = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    return attributedString
  }
  
  private func setAttributedTitleLight12(with title: String) -> NSAttributedString {
    let attributedString = title.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardDetailLight,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    return attributedString
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = DateRangePickerHeaderView()
  view.updateStartDate(to: "1231. 23. 23")
  view.updateEndDate(to: "1111. 3. 3")
  view.clearDates()
  
  return view
}
#endif
