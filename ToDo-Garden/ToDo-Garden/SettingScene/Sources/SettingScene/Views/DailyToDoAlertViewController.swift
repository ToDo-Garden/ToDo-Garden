
private extension UITableView {
  func heightStream(maxAvailableHeight: CGFloat) -> AsyncStream<CGFloat> {
    AsyncStream { continuation in
      let initialHeight = min(self.contentSize.height, maxAvailableHeight)
      continuation.yield(initialHeight)
      
      let observer = self.observe(\.contentSize, options: [.new]) { tableView, change in
        guard let newSize = change.newValue else {
          return
        }
        let newHeight = min(newSize.height, maxAvailableHeight)
        continuation.yield(newHeight)
      }
      
      continuation.onTermination = { _ in
        observer.invalidate()
      }
    }
  }
}
