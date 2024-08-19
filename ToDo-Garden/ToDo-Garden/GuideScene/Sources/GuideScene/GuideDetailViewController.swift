import ToDoGardenUIComponent

import Combine
import UIKit

final class GuideDetailViewController: UIViewController {
  private var bottomView: BottomView!
  
  var state: Guide.GuideState
  
  var contensBuilder: GuideSceneContentsBuilder
  
  // MARK: - Object lifecycle
  init(
    _ state: Guide.GuideState,
    contensBuilder: GuideSceneContentsBuilder = .live
  ) {
    self.state = state
    self.contensBuilder = contensBuilder
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bottomView = BottomView()
    self.layoutBottomView()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.bottomView.updateContents(
      self.contensBuilder.bottomContents(self.state)
    )
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
}

@available(iOS 17.0, *)
#Preview {
  GuideDetailViewController(.todoCreate)
}
