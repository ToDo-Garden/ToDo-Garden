//
//  UIFont+ToDoGarden.swift
//
//
//  Created by Noah on 2/28/24.
//

import UIKit.UIFont

extension UIFont {
	
	// MARK: - Head font style
	
	public static let pretendardHeadBold: UIFont = UIFont(
		name: PretendardFont.bold.name,
		size: 18
	) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
	
	public static let pretendardHeadSemiBold: UIFont = UIFont(
		name: PretendardFont.semibold.name,
		size: 16
	) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
	
	public static let pretendardHeadLight75: UIFont = UIFont(
		name: PretendardFont.light.name,
		size: 75
	) ?? UIFont.systemFont(ofSize: 75, weight: .light)
	
	public static let pretendardHeadBold55: UIFont = UIFont(
		name: PretendardFont.bold.name,
		size: 55
	) ?? UIFont.systemFont(ofSize: 55, weight: .bold)
	
	// MARK: - Body font style
	
	public static let pretendardBodyBold: UIFont = UIFont(
		name: PretendardFont.bold.name,
		size: 12
	) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
	
	public static let pretendardBodySemiBold: UIFont = UIFont(
		name: PretendardFont.semibold.name,
		size: 13
	) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
	
	public static let pretendardBodySemiBold15: UIFont = UIFont(
		name: PretendardFont.semibold.name,
		size: 15
	) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
	
	public static let pretendardBodyMedium: UIFont = UIFont(
		name: PretendardFont.medium.name,
		size: 13
	) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
	
	public static let pretendardBodyRegular: UIFont = UIFont(
		name: PretendardFont.regular.name,
		size: 16
	) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
	
	// MARK: - Detail font style
	
	public static let pretendardDetailRegular: UIFont = UIFont(
		name: PretendardFont.regular.name,
		size: 15
	) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
	
  public static let pretendardDetailRegular12: UIFont = UIFont(
    name: PretendardFont.regular.name,
    size: 12
  ) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
  
	public static let pretendardDetailLight: UIFont = UIFont(
		name: PretendardFont.light.name,
		size: 12
	) ?? UIFont.systemFont(ofSize: 12, weight: .light)
  
  public static let pretendardDetailRegular5: UIFont = UIFont(
    name: PretendardFont.regular.name,
    size: 5
  ) ?? UIFont.systemFont(ofSize: 5, weight: .regular)
}

public enum PretendardFont: String, CaseIterable {
	case black = "Pretendard-Black"
	case bold = "Pretendard-Bold"
	case extraBold = "Pretendard-ExtraBold"
	case extraLight = "Pretendard-ExtraLight"
	case light = "Pretendard-Light"
	case medium = "Pretendard-Medium"
	case regular = "Pretendard-Regular"
	case semibold = "Pretendard-SemiBold"
	case thin = "Pretendard-Thin"
	
	private static let extensionName: String = "otf"
	
	fileprivate var name: String {
		return self.rawValue
	}
	
	/// Font의 register는 한번만 되어야하기 때문에 아래의 flag 변수를 사용합니다.
	private static var isPretendardFontRegistered: Bool = false
	
	public static func register() {
		guard PretendardFont.isPretendardFontRegistered == false
		else { return }
		defer { PretendardFont.isPretendardFontRegistered = true }
		
		PretendardFont.allCases.forEach { font in
			guard let url = Bundle.module.url(
				forResource: font.name,
				withExtension: PretendardFont.extensionName
			)
			else { return }
			
			CTFontManagerRegisterFontsForURL(url as CFURL, CTFontManagerScope.process, nil)
		}
	}
}
