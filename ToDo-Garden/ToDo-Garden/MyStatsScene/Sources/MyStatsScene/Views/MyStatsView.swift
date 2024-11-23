//
//  MyStatsView.swift
//
//
//  Created by SONG on 11/17/24.
//

import UIKit

import TDFoundationExtension
import ToDoGardenUIComponent

final class MyStatsView: UIView {
  private let profileView: Styled.Row
  private let gardenView: GardenView
  private let longestRecordStackView: LongestRecordStackView
  private let periodicSummaryView: MyStatsPeriodicSummaryView
  
  private let constants = Constant.Layout.self
  
  init() {
    self.profileView = Styled.Row(configuration: .profile(
      .init(
        style: .myStats,
        title: "asdasd\nasdasdasd",
        description: "asdasd"
        )
      )
    )
    self.gardenView = GardenView()
    self.longestRecordStackView = LongestRecordStackView()
    self.periodicSummaryView = MyStatsPeriodicSummaryView()
    super.init(frame: CGRect.zero)
    self.setupView()
    self.backgroundColor = UIColor.white
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.setupProfileView()
    self.setupGardenView()
    self.setupLongestRecordsStackView()
    self.setupPeriodicSummaryView()
  }
  
  private func setupProfileView() {
    self.profileView.usingAutolayout()
    self.addSubview(self.profileView)
    
    NSLayoutConstraint.activate(
      [
        self.profileView.topAnchor.constraint(equalTo: self.topAnchor),
        self.profileView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.profileView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }
  
  private func setupGardenView() {
    self.gardenView.usingAutolayout()
    self.addSubview(self.gardenView)

    NSLayoutConstraint.activate(
      [
        self.gardenView.topAnchor.constraint(
          equalTo: self.profileView.bottomAnchor,
          constant: constants.topMargin
        ),
        self.gardenView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: constants.horizontalMargin
        ),
        self.gardenView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -constants.horizontalMargin
        ),
        self.gardenView.heightAnchor.constraint(equalToConstant: constants.gardenViewHeight)
      ]
    )
  }
  
  private func setupLongestRecordsStackView() {
    self.longestRecordStackView.usingAutolayout()
    self.addSubview(self.longestRecordStackView)

    NSLayoutConstraint.activate(
      [
        self.longestRecordStackView.topAnchor.constraint(
          equalTo: self.gardenView.bottomAnchor,
          constant: self.constants.topMargin
        ),
        self.longestRecordStackView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: self.constants.horizontalMargin
        ),
        self.longestRecordStackView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -self.constants.horizontalMargin
        ),
        self.longestRecordStackView.heightAnchor.constraint(
          equalToConstant: self.constants.longestRecordsViewHeight
        )
      ]
    )
  }
  
  private func setupPeriodicSummaryView() {    
    let dummyView = UIView()
    dummyView.usingAutolayout()
    self.addSubview(dummyView)
    self.periodicSummaryView.usingAutolayout()
    self.addSubview(self.periodicSummaryView)

    NSLayoutConstraint.activate(
      [
        dummyView.topAnchor.constraint(equalTo: self.longestRecordStackView.bottomAnchor),
        dummyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        
        self.periodicSummaryView.centerYAnchor.constraint(equalTo: dummyView.centerYAnchor),
        self.periodicSummaryView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: self.constants.horizontalMargin
        ),
        self.periodicSummaryView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -self.constants.horizontalMargin
        ),
        self.periodicSummaryView.heightAnchor.constraint(
          equalToConstant: self.constants.summaryViewViewHeight
        )
      ]
    )
  }
}

// MARK: Update
extension MyStatsView {
  func updateProfileView(userImage: UIImage, userName: String, dayCount: Int, dateRange: [String]) {
    let startDate = dateRange.first
    let endDate = dateRange.last
    
    var dateRangeString: String
    
    if startDate == nil || endDate == nil || startDate == endDate {
      dateRangeString = ""
    } else {
      dateRangeString = "\(startDate ?? "") ~ \(endDate ?? "")"
    }
    
    self.profileView.configuration = .profile(
      .init(
        style: .myStats,
        title: self.makeTitleString(userName: userName, dayCount: dayCount),
        description: dateRangeString,
        image: userImage
      )
    )
  }
  
  func updateGardenView(pomodoroRecordCollection: PomodoroRecordCollection) {
    self.gardenView.configure(with: pomodoroRecordCollection)
  }
  
  func updateLeftRecordStackView(groupName: String, recordCount: Int, dateRange: [String]) {
    self.longestRecordStackView.updateLeftView(groupName: groupName, recordCount: recordCount, dateRange: dateRange)
  }
  
  func updateRightRecordStackView(recordCount: Int, dateRange: [String]) {
    self.longestRecordStackView.updateRightView(recordCount: recordCount, dateRange: dateRange)
  }
  
  func updatePeriodicSummaryView(
    leftTitle: String? = nil,
    leftDescription: String,
    rightTitle: String? = nil,
    rightDescription: String
  ) {
    self.periodicSummaryView.updateSummaryView(
      leftTitle: leftTitle,
      leftDescription: leftDescription,
      rightTitle: rightTitle,
      rightDescription: rightDescription
    )
  }
  
  private func makeTitleString(userName: String, dayCount: Int) -> String {
    let fixedSuffix = Constant.StringLiteral.suffix
    let fixedNextLine = Constant.StringLiteral.nextLine
    let fixedSentence = Constant.StringLiteral.keepingDesctription
    return "\(userName)\(fixedSuffix)\(fixedNextLine)\(dayCount)\(fixedSentence)"
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = MyStatsView()

  view.usingAutolayout()
  NSLayoutConstraint.activate([
    view.widthAnchor.constraint(equalToConstant: 380),
    view.heightAnchor.constraint(equalToConstant: 700)
  ])
  return view
}
#endif
