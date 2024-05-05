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
  
  public init(configuration: Configuration) {
    self.configuration = configuration
    super.init(frame: CGRect.zero)
    self.build()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    var items = buildUnitItems()
    for _ in items {
      stackView.addArrangedSubview(items.removeFirst())
    }
  }
  
  private func buildDivider() {
    let divider = generateDivider()
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
      self.layout(on: item, with: title)
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
