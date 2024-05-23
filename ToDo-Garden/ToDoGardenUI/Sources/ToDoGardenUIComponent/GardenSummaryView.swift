//
//  GardenSummaryView.swift
//
//
//  Created by SONG on 5/5/24.
//

import UIKit

import ToDoGardenUIConstant

public final class GardenSummaryView: UIView {
  private let configuration: Configuration
  private let averageTimeLabel: UILabel
  private let averageCompleteLabel: UILabel
  
  public init(configuration: Configuration) {
    self.configuration = configuration
    self.averageTimeLabel = UILabel()
    self.averageCompleteLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(
      width: self.configuration.contents.backPlane.width,
      height: self.configuration.contents.backPlane.height
    )
  }
  
  public func update(timeText: String, completionsText: String) {
    self.averageTimeLabel.text = timeText
    self.averageCompleteLabel.text = completionsText
  }
  
  private func build() {
    // MARK: - BackgroundColor
    self.backgroundColor = UIColor.toDoGardenWhite
    
    // MARK: - layer
    self.setupLayer()
    
    // MARK: - StackView
    self.buildStackView()
    
    // MARK: - Divider
    self.buildDivider()
    
    // MARK: - Descriptions
    self.buildDescriptions()
  }
}

extension GardenSummaryView {
  private func setupLayer() {
    self.layer.cornerRadius = self.configuration.contents.backPlane.cornerRadius
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.layer.borderWidth = self.configuration.contents.backPlane.borderWidth
  }
  
  private func buildStackView() {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fillProportionally
    self.addSubview(stackView)
    stackView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        stackView.heightAnchor.constraint(equalToConstant: self.configuration.contents.backPlane.height)
      ]
    )
    let unitItems = self.buildUnitItems()
    for unitItem in unitItems {
      stackView.addArrangedSubview(unitItem)
    }
  }
  
  private func buildDivider() {
    let divider = self.generateDivider()
    divider.usingAutolayout()
    
    self.addSubview(divider)
    NSLayoutConstraint.activate(
      [
        divider.widthAnchor.constraint(equalToConstant: self.configuration.contents.line.width),
        divider.heightAnchor.constraint(equalToConstant: self.configuration.contents.line.height),
        divider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        divider.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ]
    )
  }
  
  private func buildDescriptions() {
    let rightMargin = self.configuration.contents.firstUnitItem.decriptionRightMargin
    let bottomMargin = self.configuration.contents.firstUnitItem.decriptionBottomMargin

    let labels = [self.averageTimeLabel, self.averageCompleteLabel]
    for label in labels {
      label.font = UIFont.pretendardHeadBold
      self.addSubview(label)
      label.textColor = UIColor.toDoGardenGreenDark
      label.usingAutolayout()
    }
    NSLayoutConstraint.activate(
      [
        averageTimeLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: rightMargin),
        averageTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomMargin),
        averageCompleteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: rightMargin),
        averageCompleteLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomMargin)
      ]
    )
  }
}

extension GardenSummaryView {
  private func buildUnitItems() -> [UIView] {
    var unitItems: [UIView] = []
    let itemConfigurations = [
      self.configuration.contents.firstUnitItem,
      self.configuration.contents.secondUnitItem
    ]
    
    let width = Int(self.configuration.contents.backPlane.width) / itemConfigurations.count
    let height = Int(self.configuration.contents.backPlane.height)
    
    for itemConfiguration in itemConfigurations {
      let title = generateLabel(text: itemConfiguration.title)
      
      let item = UIView(
        frame: CGRect(
          x: Int.zero,
          y: Int.zero,
          width: width,
          height: height
        )
      )
      self.setLayoutUnitItem(on: item, with: title)
      unitItems.append(item)
    }
    return unitItems
  }
  
  private func generateLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = UIFont.pretendardBodySemiBold
    label.textColor = UIColor.toDoGardenGreenDark
    return label
  }
  
  private func generateDivider() -> UIView {
    let divider = UIView()
    divider.backgroundColor = UIColor.toDoGardenGreenGray
    return divider
  }
  
  private func setLayoutUnitItem(on unitItem: UIView, with title: UILabel) {
    unitItem.addSubview(title)
    title.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        title.leadingAnchor.constraint(
          equalTo: unitItem.leadingAnchor,
          constant: self.configuration.contents.firstUnitItem.titleLeftMargin
        ),
        title.topAnchor.constraint(
          equalTo: unitItem.topAnchor,
          constant: self.configuration.contents.firstUnitItem.titleTopMargin
        )
      ]
    )
  }
}

extension GardenSummaryView {
  public struct Configuration {
    let contents: Constant.GardenSummaryView.ViewState
    
    public init(
      contents: Constant.GardenSummaryView.ViewState
    ) {
      self.contents = contents
    }
  }
}

extension GardenSummaryView.Configuration {
  public static let primary: Self = GardenSummaryView.Configuration.init(
    contents: Constant.GardenSummaryView.primary
  )
}

// #if DEBUG
// @available(iOS 17.0, *)
// #Preview {
//   let view = GardenSummaryView(configuration: GardenSummaryView.Configuration.primary)
//   view.update(timeText: "111시간 11분", completionsText: "222개")
//   return view
// }
// #endif
