//
//  LongestRecordView.swift
//
//
//  Created by SONG on 11/12/24.
//

import UIKit

import TDFoundationExtension
import ToDoGardenUIResource

public final class LongestRecordView: UIView {
  private let titleLabel: UILabel
  private let labelStackView: UIStackView
  
  public var informationButton: UIButton?
  
  public enum Configuration {
    case pomo
    case dateRange
  }
  
  public init(
    style: LongestRecordView.Configuration,
    title: String,
    groupName: String? = nil,
    recordCount: Int,
    date: [Date]
  ) {
    self.titleLabel = UILabel()
    self.labelStackView = UIStackView(frame: CGRect.zero)
    super.init(frame: CGRect.zero)
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 10.0
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
