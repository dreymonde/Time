public protocol FailureType : Error {
  var function: String { get }
  var file: String { get }
  var line: Int { get }

  var reason: String { get }
}

struct Failure : FailureType {
  let reason: String

  let function: String
  let file: String
  let line: Int

  init(reason: String, function: String = #function, file: String = #file, line: Int = #line) {
    self.reason = reason
    self.function = function
    self.file = file
    self.line = line
  }
}

struct Skip: Error {
  let reason: String?
}

public func skip(_ reason: String? = nil) -> Error {
  return Skip(reason: reason)
}


public func failure(_ reason: String? = nil, function: String = #function, file: String = #file, line: Int = #line) -> FailureType {
  return Failure(reason: reason ?? "-", function: function, file: file, line: line)
}
