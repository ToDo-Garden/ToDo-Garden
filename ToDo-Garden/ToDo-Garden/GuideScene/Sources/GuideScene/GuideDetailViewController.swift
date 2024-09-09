import CommonViews
import ToDoGardenUIComponent

import Combine
import UIKit

final class GuideDetailViewController: UIViewController {
  private var scrollView: UIScrollView!
  private var scrollViewContentsView: UIStackView!
  private var bottomView: BottomView!
  
  private var state: Guide.GuideState
  
  private var contensBuilder = GuideSceneContentsBuilder.live
  private var subscription: AnyCancellable?
  
  // MARK: - Object lifecycle
  init(_ state: Guide.GuideState) {
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.build()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.updateContents(
      self.contensBuilder.baseContents(self.state)
    )
    self.bottomView.updateContents(
      self.contensBuilder.bottomContents(self.state)
    )
  }
  
  private func updateContents(_ contents: [BaseContent]) {
    for content in contents {
      guard let view = content.viewController.view else { return }
      let dimmingView = DimmingView()
      view.addSubview(dimmingView)
      dimmingView.equalToParent()
      Task {
        let transparentRegions = content
          .transparentRegionsTask
          .map { $0() }
        dimmingView.transparentRegions = transparentRegions
      }
      
      self.scrollViewContentsView.addArrangedSubview(view)
      view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
      view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
  }
  
  private func build() {
    self.scrollView = buildScrollView()
    self.scrollView.delegate = self
    self.scrollViewContentsView = UIHStackView(
      spacing: 0,
      arrangedSubviews: []
    )
    self.bottomView = BottomView()
    self.bindingCurrentIndex()
    self.layoutScrollView()
    self.layoutBottomView()
  }
  
  private func buildScrollView() -> UIScrollView {
    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }
  
  private func layoutScrollView() {
    self.view.addSubview(self.scrollView)
    self.scrollView.equalToParent()
    self.scrollView.addSubview(self.scrollViewContentsView)
    self.scrollViewContentsView.equalToParent()
  }
  
  private func layoutBottomView() {
    self.view.addSubview(self.bottomView)
    self.bottomView.usingAutolayout()
    NSLayoutConstraint.activate([
      self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.bottomView.heightAnchor.constraint(equalToConstant: 275)
    ])
  }
  
  private func bindingCurrentIndex() {
    self.subscription = self.bottomView.$currentIndex
      .debounce(for: 0.3, scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak scrollView] index in
        scrollView?.moveTo(index: index)
      }
  }
}

extension GuideDetailViewController: UIScrollViewDelegate {
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let viewSize = scrollView.bounds.width
    let index = Int(round(scrollView.contentOffset.x / viewSize))
    self.bottomView.currentIndex = index
  }
}

@available(iOS 17.0, *)
#Preview {
  GuideDetailViewController(.todoEdit)
}
