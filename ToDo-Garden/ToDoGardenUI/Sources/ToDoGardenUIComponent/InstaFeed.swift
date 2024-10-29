import UIKit
// swiftlint:disable identifier_name
final class InstaFeedViewController: UIViewController {
  private let state: State
  struct State {
    let name: String
    let icon: UIImage
    let focusDays: Int
  }
  
  init(state: State) {
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    build()
  }
  
  private func build() {
    let template = UIImageView(image: UIImage.instaFeed)
    template.contentMode = .scaleAspectFill
    let icon = UIImageView(image: state.icon)
    let stack = self.buildStack()
    
    self.view.addSubview(template)
    template.equalToParent()
    self.view.addSubview(icon)
    icon.usingAutolayout()
    self.view.addSubview(stack)
    stack.usingAutolayout()
    
    NSLayoutConstraint.activate([
      icon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      icon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      icon.widthAnchor.constraint(equalToConstant: 241),
      icon.heightAnchor.constraint(equalToConstant: 241),
      stack.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 26),
      stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 26)
    ])
  }
  
  private func buildStack() -> UIStackView {
    UIVStackView(
      alignment: .leading,
      spacing: 2,
      arrangedSubviews: [
        self.buildLabel(state.name + ","),
        self.buildLabel("\(state.focusDays)일 째 기록 유지중!")
      ]
    )
  }
  
  private func buildLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = UIColor.toDoGardenWhite
    label.font = UIFont.gmarkSansBold
    
    return label
  }
}
// swiftlint:enable identifier_name
