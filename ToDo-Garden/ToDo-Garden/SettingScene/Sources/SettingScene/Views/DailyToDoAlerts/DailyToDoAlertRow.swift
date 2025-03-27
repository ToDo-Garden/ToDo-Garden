import UIKit

import TDFoundation
import ToDoGardenUIComponent
import ToDoGardenUIResource

class DailyToDoAlertRow: UITableViewCell {
  private let timeLabel = UILabel()
  private let editImage = UIImageView(image: UIImage.forwardButtonImage)
  private let toggleSwitch = UISwitch()
  private let deleteImage = UIImageView(image: UIImage.btnDelete)
  
  private var leadingConstraint: NSLayoutConstraint!
  
  private var editImageTrailing: NSLayoutConstraint!
  private var chevronWidth: CGFloat = 16
  
  enum Operation {
    case delete
    case editAlertTime
    case editRepeating(Bool)
  }
  var action: ((Operation) -> Void)?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(
    seconds: Double,
    isOn: Bool,
    action: ((Operation) -> Void)?
  ) {
    self.timeLabel.text = "\(seconds)"
    self.toggleSwitch.isOn = isOn
    self.action = action
  }

  private func setup() {
    self.selectionStyle = .none
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.contentView.layer.cornerRadius = 10
        
    self.setupLeftStack()
    self.setupRightStack()
  }
  
  private func setupLeftStack() {
    self.deleteImage.alpha = 0
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.deleteImageTapped))
    self.deleteImage.addGestureRecognizer(gesture)
    self.deleteImage.isUserInteractionEnabled = true
    
    self.timeLabel.font = UIFont.pretendardHeadBold
    self.timeLabel.textColor = UIColor.toDoGardenGreenDark
    
    let stack = UIHStackView(
      spacing: 10,
      arrangedSubviews: [self.deleteImage, self.timeLabel]
    )
    self.contentView.addSubview(stack)
    stack.usingAutolayout()
    self.leadingConstraint = stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17)
    NSLayoutConstraint.activate([
      self.leadingConstraint,
      stack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      
      self.deleteImage.widthAnchor.constraint(equalToConstant: 21),
      self.deleteImage.heightAnchor.constraint(equalToConstant: 21)
    ])
  }
  
  @objc func deleteImageTapped() {
    self.action?(Operation.delete)
  }
  
  private func setupRightStack() {
    self.toggleSwitch.onTintColor = UIColor.toDoGardenGreenDark
    self.toggleSwitch.addAction(
      .init { [weak self] _ in
        guard let self else { return }
        self.action?(Operation.editRepeating(self.toggleSwitch.isOn))
      },
      for: .valueChanged
    )
    self.editImage.alpha = 0
    self.editImage.isUserInteractionEnabled = true
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.editImageTapped))
    self.editImage.addGestureRecognizer(gesture)
    
    let stack = UIHStackView(arrangedSubviews: [self.toggleSwitch, self.editImage])
    self.contentView.addSubview(stack)
    stack.usingAutolayout()
    NSLayoutConstraint.activate([
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
      stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  @objc func editImageTapped() {
    self.action?(Operation.editAlertTime)
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      self.leadingConstraint.constant = editing ? 9 : 17
      self.deleteImage.isHidden = !editing
      self.deleteImage.alpha = editing ? 1 : 0
      
      self.toggleSwitch.alpha = editing ? 0 : 1
      self.toggleSwitch.isHidden = editing
      
      self.editImage.alpha = editing ? 1 : 0
      self.editImage.isHidden = !editing
      self.layoutIfNeeded()
    }
  }
}
