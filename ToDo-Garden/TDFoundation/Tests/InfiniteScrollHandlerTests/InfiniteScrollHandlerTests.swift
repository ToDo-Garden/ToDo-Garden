//
//  InfiniteScrollHandlerTests.swift
//  TDFoundation
//
//  Created by SONG on 2/11/25.
//
// swiftlint:disable all
import UIKit
import Testing

@testable import TDFoundation

@Suite("ScrollView Extension Tests")
@MainActor
final class ScrollViewTests {
  @Test("스크롤뷰가 하단에 도달했을 때 onEndReached가 호출되어야 한다")
  func testEndReachedCallback() async throws {
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    scrollView.contentSize = CGSize(width: 300, height: 1000)
    
    var endReachedCallCount = 0
    scrollView.onEndReached = {
      endReachedCallCount += 1
    }
    let nearBottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height - 100)
    scrollView.setContentOffset(nearBottomOffset, animated: false)
    InfiniteScrollHandler.shared.scrollViewDidScroll(scrollView)
    
    #expect(endReachedCallCount == 2)
  }
  
  @Test("delegate 메서드가 정상적으로 포워딩되어야 한다")
  func testDelegateForwarding() async throws {
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    let mockDelegate = MockScrollViewDelegate()
    scrollView.delegate = mockDelegate
    scrollView.onEndReached = {}
    
    #expect(scrollView.delegate === InfiniteScrollHandler.shared)
    
    let target = InfiniteScrollHandler.shared.originalDelegates[scrollView] as? UIScrollViewDelegate
    #expect(target === mockDelegate)
    
    scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
    InfiniteScrollHandler.shared.scrollViewDidScroll(scrollView)
    
    #expect(mockDelegate.scrollDidCallCount == 2)
  }
  
  @Test("여러 스크롤뷰가 독립적으로 동작해야 한다")
  func testMultipleScrollViews() async throws {
    let firstScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    let secondScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    firstScrollView.contentSize = CGSize(width: 300, height: 1000)
    secondScrollView.contentSize = CGSize(width: 300, height: 1000)
    
    var firstScrollEndReachedCount = 0
    var secondScrollEndReachedCount = 0
    firstScrollView.onEndReached = { firstScrollEndReachedCount += 1 }
    secondScrollView.onEndReached = { secondScrollEndReachedCount += 1 }
    
    let nearBottomOffset = CGPoint(x: 0, y: firstScrollView.contentSize.height - firstScrollView.frame.height - 100)
    firstScrollView.setContentOffset(nearBottomOffset, animated: false)
    InfiniteScrollHandler.shared.scrollViewDidScroll(firstScrollView)
    
    #expect(firstScrollEndReachedCount == 2)
    #expect(secondScrollEndReachedCount == 0)
  }
  
  @Test("스크롤뷰의 threshold 값이 제대로 적용되어야 한다")
  func testScrollThreshold() async throws {
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    scrollView.contentSize = CGSize(width: 300, height: 1000)
    
    var endReachedCallCount = 0
    scrollView.onEndReached = {
      endReachedCallCount += 1
    }
    
    let farFromBottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height - 300)
    scrollView.setContentOffset(farFromBottomOffset, animated: false)
    InfiniteScrollHandler.shared.scrollViewDidScroll(scrollView)
    
    #expect(endReachedCallCount == 0, "threshold보다 멀 때는 호출되지 않아야 함")
    
    let nearBottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height - 100)
    scrollView.setContentOffset(nearBottomOffset, animated: false)
    InfiniteScrollHandler.shared.scrollViewDidScroll(scrollView)
    
    #expect(endReachedCallCount == 2, "threshold 내에 있을 때는 호출되어야 함")
  }
  
  @Test("InfiniteScrollHandler가 delegate 메서드 응답을 올바르게 처리해야 한다")
  func testDelegateResponding() async throws {
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
    let mockDelegate = MockScrollViewDelegate()
    scrollView.delegate = mockDelegate
    scrollView.onEndReached = {}
    
    let selector = #selector(UIScrollViewDelegate.scrollViewDidScroll(_:))
    #expect(InfiniteScrollHandler.shared.responds(to: selector))
    
    let target = InfiniteScrollHandler.shared.forwardingTarget(for: selector) as? UIScrollViewDelegate
    #expect(target === mockDelegate)
  }
}
// swiftlint:enable all
