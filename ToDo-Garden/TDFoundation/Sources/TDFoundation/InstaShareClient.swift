import UIKit

import ToDoGardenUIComponent

// swiftlint:disable identifier_name
public struct InstaShareClient {
  var _imageData: (String, UIImage, Int) throws -> Data
  var _setItem: (Data) -> Void
  var _apiID: () throws -> String
  var _openInstagram: (String) throws -> Void
  
  init(
    imageData: @escaping (String, UIImage, Int) throws -> Data,
    setItem: @escaping (Data) -> Void,
    apiID: @escaping () throws -> String,
    openInstagram: @escaping (String) throws -> Void
  ) {
    self._imageData = imageData
    self._setItem = setItem
    self._apiID = apiID
    self._openInstagram = openInstagram
  }
  
  public func story(name: String, icon: UIImage, focusDays: Int) throws {
    let data = try self._imageData(name, icon, focusDays)
    self._setItem(data)
    try self._openInstagram(self._apiID())
  }
}

extension InstaShareClient {
  public enum InternalError: Error {
    case unexpected
    case notInstalled
    case missingAPIKey
  }
  
  @MainActor
  public static let live = Self(
    imageData: { name, icon, focusDays in
      let image = InstaFeedViewController(
        state: InstaFeedViewController.State(
          name: name,
          icon: icon,
          focusDays: focusDays
        )
      )
      .view
      .snapshot
      guard let data = image.pngData() else {
        throw InternalError.unexpected
      }
      return data
    },
    setItem: { data in
      let pasteItem = [
        "com.instagram.sharedSticker.backgroundImage": data
      ]
      let options = [
        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60)
      ]
      UIPasteboard.general.setItems([pasteItem])
    },
    apiID: {
      guard
        let id = Bundle.main.infoDictionary?["facebookAPIKey"] as? String
      else { throw InternalError.missingAPIKey }
      return id
    },
    openInstagram: { id in
      guard
        let url = URL(string: "instagram-stories://share?source_application=\(id)")
      else { throw URLError(.badURL) }
      guard UIApplication.shared.canOpenURL(url) else { throw InternalError.notInstalled }
      UIApplication.shared.open(url)
    }
  )
}

// MARK: - Helper
private extension UIView {
  var snapshot: UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
    let image = renderer.image { _ in
      self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
    }
    return image
  }
}

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
