import UIKit

import TDFoundation
import TDUtility
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIResource

class DailyToDoAlertRow: UITableViewCell, HapticFeedbackable {
  private let timeLabel = UILabel()
  private let editImage = UIImageView(image: UIImage.forwardButtonImage)
  private var leftStack: UIStackView!
  private let toggleSwitch = UISwitch()
  private let deleteImage = UIImageView(image: UIImage.btnDelete)
  
  private var leadingConstraint: NSLayoutConstraint!
  private var toggleSwitchTrailing: NSLayoutConstraint!
  private var deleteImageTrailing: NSLayoutConstraint!
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    timeLabel.text = "0:00"
    action = nil
  }
  
  func configure(
    seconds: Double,
    isOn: Bool,
    action: ((Operation) -> Void)?
  ) {
    let minute = String(format: "%02d", Int(seconds.minute()))
    self.timeLabel.text = "\(Int(seconds.hour)):" + minute
    self.toggleSwitch.isOn = isOn
    self.action = action
  }
  
  private func setup() {
    self.setupContentView()
    self.setupLeftStack()
    self.setupToggleSwitch()
    self.setupEditImage()
  }
  
  private func setupContentView() {
    self.backgroundColor = UIColor.toDoGardenWhite
    self.selectionStyle = .none
    self.contentView.layer.borderWidth = 1
    self.contentView.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
    self.contentView.layer.cornerRadius = 10
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
    self.addGestureRecognizer(gesture)
  }
  
  @objc func tapped() {
    guard self.isEditing else { return }
    self.action?(Operation.editAlertTime)
  }
  
  private func setupLeftStack() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.deleteImageTapped))
    self.deleteImage.addGestureRecognizer(gesture)
    self.deleteImage.isUserInteractionEnabled = true
    
    self.timeLabel.font = UIFont.pretendardHeadBold
    self.timeLabel.textColor = UIColor.toDoGardenGreenDark
    
    self.leftStack = UIHStackView(
      spacing: 10,
      arrangedSubviews: [self.deleteImage, self.timeLabel]
    )
    self.contentView.addSubview(leftStack)
    self.leftStack.usingAutolayout()
    self.leadingConstraint = leftStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17)
    NSLayoutConstraint.activate([
      self.leadingConstraint,
      self.leftStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      
      self.deleteImage.widthAnchor.constraint(equalToConstant: 21),
      self.deleteImage.heightAnchor.constraint(equalToConstant: 21)
    ])
  }
  
  @objc func deleteImageTapped() {
    let style = UIImpactFeedbackGenerator.FeedbackStyle.medium
    self.triggerHapticFeedback(type: HapticFeedbackType.impact(style: style))
    self.action?(Operation.delete)
  }
  
  private func setupToggleSwitch() {
    self.toggleSwitch.onTintColor = UIColor.toDoGardenGreenDark
    self.toggleSwitch.addAction(
      UIAction { [weak self] _ in
        guard let self else { return }
        self.action?(Operation.editRepeating(self.toggleSwitch.isOn))
      },
      for: .valueChanged
    )
    self.toggleSwitch.usingAutolayout()
    self.addSubview(toggleSwitch)
    self.toggleSwitchTrailing = self.toggleSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17)
    NSLayoutConstraint.activate([
      self.toggleSwitchTrailing,
      self.toggleSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  private func setupEditImage() {
    self.editImage.isUserInteractionEnabled = true
    self.editImage.usingAutolayout()
    self.addSubview(editImage)
    self.editImageTrailing = editImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 25)
    NSLayoutConstraint.activate([
      self.editImageTrailing,
      self.editImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    UIView.animate(withDuration: 0.3) {
      self.leftStack.spacing = editing ? 10 : 17
      self.deleteImage.alpha = editing ? 1 : 0
      self.leadingConstraint.constant = editing ? 9 : -25
      
      self.toggleSwitch.alpha = editing ? 0 : 1
      self.toggleSwitchTrailing.constant = editing ? 25 : -17
      self.editImage.alpha = editing ? 1 : 0
      self.editImageTrailing.constant = editing ? -17 : 25
      self.layoutIfNeeded()
    }
  }
}
