import UIKit

import ToDoGardenUIResource

public final class CoverViewController: UIViewController {
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    let imageView = UIImageView(image: UIImage.cover)
    imageView.contentMode = .scaleAspectFit
    self.view.addSubview(imageView)
    imageView.usingAutolayout()
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 64)
    ])
    self.view.backgroundColor = UIColor.toDoGardenBeige
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  CoverViewController()
}
#endif
