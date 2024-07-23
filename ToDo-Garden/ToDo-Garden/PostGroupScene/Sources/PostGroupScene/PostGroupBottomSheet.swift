import Combine
import UIKit

import TDFoundationExtension
import ToDoGardenUIAPI
import ToDoGardenUIResource

final class PostGroupBottomSheet: UIViewController {
  weak var delegate: PostGroupBottomSheetDelegate?
  private let dimmedView: UIView
  private let bottomSheetView: UIView
  private let grabberView: UIView
  private let colorPickerList: ColorPickerListAPI
  private let doneBottomButton: UIButton
  
  private var bottomSheetHeight: CGFloat {
    return view.bounds.height * Constant.BottomSheet.multiplier
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  init(colorPickerList: ColorPickerListAPI, bottomButton: UIButton) {
    self.dimmedView = UIView()
    self.bottomSheetView = UIView()
    self.grabberView = UIView()
    self.colorPickerList = colorPickerList
    self.doneBottomButton = bottomButton
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    self.setupGesture()
    self.setupBindings()
    self.setupButtonAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.animatePresenting()
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    UIView.animate(
      withDuration: Constant.BottomSheet.Animation.duration,
      animations: { [weak self] in
        self?.dimmedView.alpha = CGFloat.zero
        self?.bottomSheetView.transform = CGAffineTransform(
          translationX: CGFloat.zero,
          y: self?.bottomSheetHeight ?? CGFloat.zero
        )
      },
      completion: { _ in
        super.dismiss(animated: false, completion: completion)
      }
    )
  }
  
  func setupCurrentColor(color: UIColor?) {
    guard let color = color else {
      return
    }
    
    let index = self.colorPickerList.colors.firstIndex(of: color)
    self.colorPickerList.selected.send(index)
  }
}

extension PostGroupBottomSheet {
  private func setupView() {
    self.view.backgroundColor = UIColor.clear
    self.setupDimmedView()
    self.setupBottomSheetView()
    self.setupGrabberView()
    self.setupNavigationBar()
    self.setupColorPickerList()
    self.setupBottomButton()
  }
  
  private func setupDimmedView() {
    self.dimmedView.backgroundColor = UIColor.black.withAlphaComponent(Constant.BottomSheet.DimmedView.normalAlpha)
    self.dimmedView.alpha = CGFloat.zero
    self.view.addSubview(self.dimmedView)
    
    self.dimmedView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.dimmedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.dimmedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
  }
  
  private func setupBottomSheetView() {
    self.bottomSheetView.backgroundColor = UIColor.white
    self.bottomSheetView.layer.cornerRadius = Constant.BottomSheet.BottomSheetView.cornerRadius
    self.bottomSheetView.layer.masksToBounds = true
    self.view.addSubview(self.bottomSheetView)
    
    self.bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.bottomSheetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.bottomSheetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.bottomSheetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.bottomSheetView.heightAnchor.constraint(equalToConstant: self.bottomSheetHeight)
    ])
  }
  
  private func setupGrabberView() {
    self.grabberView.backgroundColor = UIColor.lightGray
    self.grabberView.layer.cornerRadius = Constant.BottomSheet.GrabberView.cornerRadius
    self.bottomSheetView.addSubview(self.grabberView)
    
    self.grabberView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.grabberView.topAnchor.constraint(
        equalTo: self.bottomSheetView.topAnchor,
        constant: Constant.BottomSheet.GrabberView.topMargin
      ),
      self.grabberView.centerXAnchor.constraint(equalTo: self.bottomSheetView.centerXAnchor),
      self.grabberView.widthAnchor.constraint(equalToConstant: Constant.BottomSheet.GrabberView.width),
      self.grabberView.heightAnchor.constraint(equalToConstant: Constant.BottomSheet.GrabberView.height)
    ])
  }
  
  private func setupColorPickerList() {
    let topMargin = self.bottomSheetHeight / Constant.BottomSheet.ColorPickerList.multiplier
    self.bottomSheetView.addSubview(self.colorPickerList)
    
    self.colorPickerList.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.colorPickerList.topAnchor.constraint(equalTo: self.bottomSheetView.topAnchor, constant: topMargin),
      self.colorPickerList.centerXAnchor.constraint(equalTo: self.bottomSheetView.centerXAnchor)
    ])
  }
  
  private func setupBottomButton() {
    let bottomMargin = self.bottomSheetHeight / Constant.BottomSheet.BottomButton.multiplier
    self.bottomSheetView.addSubview(self.doneBottomButton)
    
    self.doneBottomButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.doneBottomButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.doneBottomButton.bottomAnchor.constraint(equalTo: self.bottomSheetView.bottomAnchor, constant: bottomMargin)
    ])
  }
  
  private func animatePresenting() {
    self.dimmedView.alpha = CGFloat.zero
    self.bottomSheetView.transform = CGAffineTransform(
      translationX: CGFloat.zero,
      y: self.bottomSheetHeight
    )
    
    UIView.animate(withDuration: Constant.BottomSheet.Animation.duration) {
      self.dimmedView.alpha = Constant.BottomSheet.DimmedView.presentingAlpha
      self.bottomSheetView.transform = CGAffineTransform.identity
    }
  }
  
  private func setupNavigationBar() {
    let navigationBarView = createNavigationBarView()
    let titleLabel = createTitleLabel()
    let cancelButton = createCancelButton()
    
    navigationBarView.addSubview(titleLabel)
    navigationBarView.addSubview(cancelButton)
    bottomSheetView.addSubview(navigationBarView)
    
    setupConstraints(for: navigationBarView, titleLabel: titleLabel, cancelButton: cancelButton)
  }
  
  private func createNavigationBarView() -> UIView {
    let navigationBarView = UIView()
    navigationBarView.backgroundColor = UIColor.clear
    navigationBarView.translatesAutoresizingMaskIntoConstraints = false
    return navigationBarView
  }
  
  private func createTitleLabel() -> UILabel {
    let titleLabel = UILabel()
    let titleLabelText = Constant.BottomSheet.StringLiteral.title
    
    titleLabel.attributedText = titleLabelText.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardHeadBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }
  
  private func createCancelButton() -> UIButton {
    let cancelButton = UIButton(type: .system)
    let text = Constant.BottomSheet.StringLiteral.cancel
    
    cancelButton.setAttributedTitle(text.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodyRegular,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    ), for: UIControl.State.normal)
    
    cancelButton.backgroundColor = UIColor.clear
    cancelButton.addAction(UIAction { _ in self.dismiss(animated: true) }, for: UIControl.Event.touchUpInside)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }
  
  private func setupConstraints(
    for navigationBarView: UIView,
    titleLabel: UILabel,
    cancelButton: UIButton
  ) {
    let topMargin = self.bottomSheetHeight / Constant.BottomSheet.NavigationBar.multiplier
    NSLayoutConstraint.activate(
      [
        navigationBarView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: topMargin),
        navigationBarView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
        navigationBarView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
        navigationBarView.heightAnchor.constraint(
          equalToConstant: Constant.BottomSheet.NavigationBar.height
        ),
        
        titleLabel.centerXAnchor.constraint(equalTo: navigationBarView.centerXAnchor),
        titleLabel.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor),
        
        cancelButton.trailingAnchor.constraint(
          equalTo: navigationBarView.trailingAnchor,
          constant: Constant.BottomSheet.NavigationBar.trailingMargin
        ),
        cancelButton.centerYAnchor.constraint(equalTo: navigationBarView.centerYAnchor)
      ]
    )
  }
}

extension PostGroupBottomSheet {
  private func setupGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
    self.dimmedView.addGestureRecognizer(tapGesture)
  }
  
  @objc private func handleTap(_ sender: UITapGestureRecognizer) {
    self.dismiss(animated: true, completion: nil)
  }
  
  private func setupBindings() {
    self.colorPickerList.selected
      .sink { [weak self] selectedIndex in
        self?.doneBottomButton.isEnabled = selectedIndex != nil
      }
      .store(in: &self.subscriptions)
  }
  
  private func setupButtonAction() {
    self.doneBottomButton.addAction(UIAction { _ in
      guard let index = self.colorPickerList.selected.value else {
        return
      }
      let color = self.colorPickerList.colors[index]
      self.delegate?.dismissedBottomSheet(color: color)
      self.dismiss(animated: true)
    }, for: UIControl.Event.touchUpInside)
  }
}

protocol PostGroupBottomSheetDelegate: AnyObject {
  func dismissedBottomSheet(color: UIColor)
}

// MARK: Preview : PostGroupScene의 Package.swift에 있는 주석처리를 해제해주세요.

// import ToDoGardenUIComponent
// #if DEBUG
// @available(iOS 17.0, *)
// #Preview {
//  let subject =  CurrentValueSubject<Int?, Never>(nil)
//  
//  let colorPickerList = ColorPickerList(colors: [
//    .toDoGardenBlack,
//    .toDoGardenBlue,
//    .toDoGardenBrown,
//    .toDoGardenEditButtonBlue,
//    .toDoGardenEditButtonRed,
//    .toDoGardenEditButtonYellow,
//    .toDoGardenGrassHigh,
//    .toDoGardenGrassLow,
//    .toDoGardenGrassMiddle,
//    .toDoGardenGray,
//    .toDoGardenOlive,
//    .toDoGardenPink
//  ], itemsPerRow: 6, selected: subject)
//  
//  let button = ToDoGardenBoxButton(title: "확인", buttonType: .primaryRoundRectButton)
//  
//  let vc = PostGroupBottomSheet(colorPickerList: colorPickerList, bottomButton: button)
//  
//  return vc
// }
// #endif
