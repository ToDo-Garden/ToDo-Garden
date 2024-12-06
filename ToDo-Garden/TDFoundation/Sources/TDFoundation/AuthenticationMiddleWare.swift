import HTTPClientAPI

public struct AuthenticationMiddleWare: ClientMiddleware {
  public init() { }
  
  public func intercept(
    request: HTTPRequest,
    next: (HTTPRequest) async throws -> HTTPResponse
  ) async throws -> HTTPResponse {
    var copy = request
    copy.header["apiKey"] = try KeyConstants.facebookAPIKey
    
    return try await next(copy)
  }
}
