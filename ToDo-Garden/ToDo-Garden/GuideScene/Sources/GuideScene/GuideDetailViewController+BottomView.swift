import ToDoGardenUIComponent

import Combine
import UIKit

extension GuideDetailViewController {
  final class BottomView: UIView {
    private var stepLabel: UILabel!
    private var scrollView: UIScrollView!
    private var contentsView: UIStackView!
    private var leftButton: UIButton!
    private var rightButton: UIButton!
    
    @Published var currentIndex: Int = 0
    private var subviewCount: Int = 0
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.initialTask()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    override func safeAreaInsetsDidChange() {
      super.safeAreaInsetsDidChange()
      guard safeAreaInsets.bottom != 0 else { return }
      self.layoutButtons()
    }
    
    func updateContents(_ contents: [UIView]) {
      self.subviewCount = contents.count
      self.updateStepLabel()
      for content in contents {
        let view = UIView()
        view.addSubview(content)
        content.usingAutolayout()
        NSLayoutConstraint.activate([
          content.topAnchor.constraint(equalTo: view.topAnchor),
          content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
          content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
          content.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.contentsView.addArrangedSubview(view)
        view.usingAutolayout()
        view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
      }
    }
    
    private func initialTask() {
      let container = self.buildContainer()
      self.addSubview(container)
      let forwardAction = UIAction { [weak self] _ in
        self?.moveTo(forward: true)
      }
      self.leftButton = self.buildButton(
        UIImage.backwardButtonImage,
        action: forwardAction
      )
      self.addSubview(self.leftButton)
      let backwardAction = UIAction { [weak self] _ in
        self?.moveTo(forward: false)
      }
      self.rightButton = self.buildButton(
        UIImage.forwardButtonImage,
        action: backwardAction
      )
      self.addSubview(self.rightButton)
      self.layoutContainer(container)
      self.layoutButtons()
      self.leftButton.isHidden = true
    }
    
    private func moveTo(forward: Bool) {
      let count = forward ? 1 : -1
      let rowWidth = self.scrollView.bounds.width * CGFloat(count)
      self.currentIndex += count
      self.scrollView.setContentOffset(
        .init(x: self.scrollView.contentOffset.x - rowWidth, y: 0),
        animated: true
      )
    }
    
    private func buildContainer() -> UIView {
      let header = self.buildBottomHeaderView()
      let scrollView = self.buildScrollView()
      let stack = UIStackView(arrangedSubviews: [header, scrollView])
      stack.axis = .vertical
      
      return stack
    }
    
    private func buildBottomHeaderView() -> UIView {
      let button = self.buildCloseButton()
      self.stepLabel = self.buildStepLabel()
      let spacing = self.buildSpacing(width: button.intrinsicContentSize.width)
      
      let stack = UIStackView(arrangedSubviews: [button, self.stepLabel, spacing])
      stack.isLayoutMarginsRelativeArrangement = true
      stack.distribution = .equalCentering
      
      return stack
    }
    
    private func buildCloseButton() -> UIButton {
      let action = UIAction { _ in
        
      }
      let button = UIButton(primaryAction: action)
      button.configuration = .plain()
      button.configuration?.title = "나가기"
      button.configuration?.titleTextAttributesTransformer = .init { configuration in
        var copy = configuration
        copy.font = UIFont.pretendardDetailLight
        copy.foregroundColor = UIColor.toDoGardenGreenDark
        return copy
      }
      button.configuration?.contentInsets = .init(top: 0, leading: 25, bottom: 0, trailing: 8)
      
      return button
    }
    
    private func buildSpacing(width: CGFloat) -> UIView {
      let spacing = UIView()
      spacing.widthAnchor.constraint(equalToConstant: width).isActive = true
      
      return spacing
    }
    
    private func buildScrollView() -> UIScrollView {
      let scrollView = UIScrollView()
      scrollView.isPagingEnabled = true
      scrollView.showsHorizontalScrollIndicator = false
      scrollView.delegate = self
      self.scrollView = scrollView
      
      let stack = UIStackView()
      scrollView.addSubview(stack)
      self.contentsView = stack
      
      return scrollView
    }
    
    private func buildStepLabel() -> UILabel {
      let label = UILabel()
      label.font = UIFont.pretendardBodyBold
      label.textColor = UIColor.toDoGardenGreenDark
      
      return label
    }
    
    private func buildButton(_ image: UIImage, action: UIAction) -> UIButton {
      let button = UIButton(primaryAction: action)
      button.configuration = .plain()
      button.configuration?.image = image
      button.layer.zPosition = 1
      
      return button
    }
    
    private func layoutContainer(_ container: UIView) {
      container.equalToParent()
      self.stepLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
      self.contentsView.equalToParent()
    }
    
    private func layoutButtons() {
      self.leftButton.usingAutolayout()
      let safeAreaBottom = -self.safeAreaInsets.bottom / 2
      NSLayoutConstraint.activate([
        self.leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
        self.leftButton.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: safeAreaBottom),
        self.leftButton.widthAnchor.constraint(equalToConstant: 24),
        self.leftButton.heightAnchor.constraint(equalToConstant: 24)
      ])
      self.rightButton.usingAutolayout()
      NSLayoutConstraint.activate([
        self.rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        self.rightButton.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor, constant: safeAreaBottom),
        self.rightButton.widthAnchor.constraint(equalToConstant: 24),
        self.rightButton.heightAnchor.constraint(equalToConstant: 24)
      ])
      
    }
  }
}

extension GuideDetailViewController.BottomView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let viewSize = scrollView.bounds.width
    let index = Int(round(scrollView.contentOffset.x / viewSize))
    self.currentIndex = index
    self.updateStepLabel(currentIndex)
    self.updateButtons()
  }
  
  private func updateStepLabel(_ index: Int = 0) {
    self.stepLabel.text = "\(index + 1)/\(self.subviewCount)"
  }
  
  private func updateButtons() {
    if self.currentIndex == 0 {
      self.leftButton.isHidden = true
      self.rightButton.isHidden = false
    } else if self.currentIndex == self.subviewCount - 1 {
      self.leftButton.isHidden = false
      self.rightButton.isHidden = true
    } else {
      self.leftButton.isHidden = false
      self.rightButton.isHidden = false
    }
  }
}
