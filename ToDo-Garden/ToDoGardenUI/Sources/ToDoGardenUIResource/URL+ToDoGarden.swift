//
//  URL+ToDoGarden.swift
//
//
//  Created by SONG on 10/29/24.
//

import Foundation

extension URL {
  public static var loadingIndicatorURL: URL? {
    return loadJsonURL(named: "LoadingIndicator")
  }
  
  public static var onBoardingURL: URL? {
    return loadJsonURL(named: "OnBoarding")
  }
  private static func loadJsonURL(named name: String) -> URL? {
    let url = Bundle.module.url(forResource: "LottieJsons/\(name)", withExtension: "json") ?? nil
    return url
    
  }
}
