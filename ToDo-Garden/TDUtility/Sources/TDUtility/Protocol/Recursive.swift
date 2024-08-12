//
//  Recursive.swift
//  TDUtility
//
//  Created by Noah on 8/8/24.
//

import Foundation

typealias VoidBlock = () -> Void
typealias RecursiveBlock<T> = (T) -> Void

protocol Recursive {
  associatedtype Element: IterableElement
  func recursiveSearch(leafBlock: VoidBlock, recursiveBlock: RecursiveBlock<Element>)
}
