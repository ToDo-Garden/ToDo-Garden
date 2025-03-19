import UIKit

import ToDoGardenUIComponent

// swiftlint:disable function_body_length
final class ToDoListViewForGuide: UIView {
  private var header: ToDoGroupSectionHeaderView!
  private var row: UIView!
  private var arrow: UIView!
  private var actionStack: UIView!
  
  private var rowLeading: NSLayoutConstraint!
  private var arrowCenter: NSLayoutConstraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
    
    Task {
      self.rowLeading.constant = -30
      self.arrowCenter.constant = -30
      UIView.animate(withDuration: 0.6, delay: 1, options: .curveEaseInOut) {
        self.layoutIfNeeded()
      }
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.header = ToDoGroupSectionHeaderView()
    self.header.update(
      with: .init(
        progressColor: UIColor.toDoGardenYellow,
        progressRate: 0.5,
        groupTitle: "그룹 1"
      )
    )
    self.header.usingAutolayout()
    self.addSubview(self.header)
    
    self.row = Styled.Row(
      configuration: .todoList(
        .init(
          text: "오늘의 투두",
          foregroundColor: .toDoGardenYellow,
          isSelected: true
        )
      )
    )
    self.row.usingAutolayout()
    self.addSubview(self.row)
    
    self.actionStack = self.buildActionStack()
    self.actionStack.usingAutolayout()
    self.addSubview(self.actionStack)
    
    self.arrow = UIImageView(image: UIImage.leftArrow)
    self.arrow.usingAutolayout()
    self.addSubview(self.arrow)
    
    let leftView = UIView()
    leftView.backgroundColor = .white
    leftView.usingAutolayout()
    self.addSubview(leftView)
    NSLayoutConstraint.activate([
      leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
      leftView.topAnchor.constraint(equalTo: header.bottomAnchor),
      leftView.bottomAnchor.constraint(equalTo: bottomAnchor),
      leftView.widthAnchor.constraint(equalToConstant: 20)
    ])
  }
  
  private func buildActionStack() -> UIHStackView {
    let editView = UIImageView(image: UIImage.editIconImage.withRenderingMode(.alwaysTemplate))
    editView.tintColor = UIColor.toDoGardenWhite
    editView.contentMode = UIView.ContentMode.scaleAspectFit
    editView.backgroundColor = UIColor.toDoGardenEditButtonOrange
    
    let deleteView = UIImageView(image: UIImage.deleteIconImage)
    deleteView.contentMode = UIView.ContentMode.scaleAspectFit
    deleteView.backgroundColor = UIColor.toDoGardenEditButtonRed
    
    let stack = UIHStackView(spacing: 0, arrangedSubviews: [editView, deleteView])
    NSLayoutConstraint.activate([
      editView.widthAnchor.constraint(equalToConstant: 78),
      deleteView.widthAnchor.constraint(equalToConstant: 78)
    ])
    
    return stack
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: self.topAnchor),
      header.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      header.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
    
    self.rowLeading = self.row.leadingAnchor.constraint(equalTo: self.leadingAnchor)
    NSLayoutConstraint.activate([
      self.rowLeading,
      self.row.topAnchor.constraint(equalTo: self.header.bottomAnchor),
      self.row.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.row.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -156)
    ])
    
    NSLayoutConstraint.activate([
      self.actionStack.leadingAnchor.constraint(equalTo: self.row.trailingAnchor, constant: 30),
      self.actionStack.topAnchor.constraint(equalTo: self.header.bottomAnchor),
      self.actionStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    
    self.arrowCenter = self.arrow.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    NSLayoutConstraint.activate([
      self.arrowCenter,
      self.arrow.centerYAnchor.constraint(equalTo: self.row.centerYAnchor)
    ])
  }
}

// swiftlint:enable function_body_length

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  ToDoListViewForGuide()
}
#endif
