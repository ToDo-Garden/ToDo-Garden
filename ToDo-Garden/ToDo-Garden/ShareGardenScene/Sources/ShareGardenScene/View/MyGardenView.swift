//
//  MyGardenView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/13/24.
//

import UIKit

import TDUtility
import ToDoGardenUIResource

extension ShareGardenSceneViewController {
  final class MyGardenView: UIStackView {
    
    // MARK: - UI Properties
    
    private let sectionHeaderView: SectionHeaderView = {
      let shareButton = UIButton()
      shareButton.setImage(UIImage.shareIconImage, for: UIControl.State.normal)
      
      let sectionHeaderView = SectionHeaderView(
        sectionTitle: "나의 가든",
        rightActionButton: shareButton
      )
      
      return sectionHeaderView
    }()
    
    // MARK: - Properties
    
    @ExecuteOnce private var setupLayoutIfNeeded: (() -> Void)?
    
    init() {
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.setupLayoutIfNeeded = {
        self.setupLayoutConstraints()
      }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

extension ShareGardenSceneViewController.MyGardenView {
  private func setup() {
    self.setupStackView()
    self.addSubviews()
  }
  
  private func setupStackView() {
    self.spacing = 14
    self.distribution = UIStackView.Distribution.fillEqually
    self.axis = NSLayoutConstraint.Axis.vertical
    self.alignment = UIStackView.Alignment.center
  }
  
  private func addSubviews() {
    self.addArrangedSubview(self.sectionHeaderView)
  }
}

extension ShareGardenSceneViewController.MyGardenView {
  private func setupLayoutConstraints() {
    self.setupSectionHeaderViewLayoutConstraints()
  }
  
  private func setupSectionHeaderViewLayoutConstraints() {
    let leadingMargin: CGFloat = self.bounds.width * (28 / 375)
    let trailingMargin: CGFloat = self.bounds.width * (24 / 375)
    
    NSLayoutConstraint.activate([
      self.sectionHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingMargin),
      self.sectionHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailingMargin)
    ])
  }
}
