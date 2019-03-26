public protocol ExpectationType {
  associatedtype ValueType
  var expression: () throws -> ValueType? { get }
  func failure(_ reason: String) -> FailureType
}


struct ExpectationFailure : FailureType {
  let file: String
  let line: Int
  let function: String

  let reason: String

  init(reason: String, file: String, line: Int, function: String) {
    self.reason = reason
    self.file = file
    self.line = line
    self.function = function
  }
}

open class Expectation<T> : ExpectationType {
  public typealias ValueType = T
  public let expression: () throws -> ValueType?

  let file: String
  let line: Int
  let function: String

  open var to: Expectation<T> {
    return self
  }

  init(file: String, line: Int, function: String, expression: @escaping () throws -> ValueType?) {
    self.file = file
    self.line = line
    self.function = function
    self.expression = expression
  }

  open func failure(_ reason: String) -> FailureType {
    return ExpectationFailure(reason: reason, file: file, line: line, function: function)
  }
}

public func expect<T>( _ expression: @autoclosure @escaping () throws -> T?, file: String = #file, line: Int = #line, function: String = #function) -> Expectation<T> {
  return Expectation(file: file, line: line, function: function, expression: expression)
}

public func expect<T>(_ file: String = #file, line: Int = #line, function: String = #function, expression: @escaping () throws -> T?)  -> Expectation<T> {
  return Expectation(file: file, line: line, function: function, expression: expression)
}

// MARK: Equatability

public func == <E: ExpectationType>(lhs: E, rhs: E.ValueType) throws where E.ValueType: Equatable {
  if let value = try lhs.expression() {
    if value != rhs {
      throw lhs.failure("\(String(describing: value)) is not equal to \(rhs)")
    }
  } else {
    throw lhs.failure("given value is nil")
  }
}

public func != <E: ExpectationType>(lhs: E, rhs: E.ValueType) throws where E.ValueType: Equatable {
  let value = try lhs.expression()
  if value == rhs {
    throw lhs.failure("\(String(describing: value)) is equal to \(rhs)")
  }
}

// MARK: Array Equatability

public func == <Element: Equatable> (lhs: Expectation<[Element]>, rhs: [Element]) throws {
  if let value = try lhs.expression() {
    if value != rhs {
      throw lhs.failure("\(String(describing: value)) is not equal to \(rhs)")
    }
  } else {
    throw lhs.failure("given value is nil")
  }
}

public func != <Element: Equatable> (lhs: Expectation<[Element]>, rhs: [Element]) throws {
  if let value = try lhs.expression() {
    if value == rhs {
      throw lhs.failure("\(String(describing: value)) is equal to \(rhs)")
    }
  } else {
    throw lhs.failure("given value is nil")
  }
}

// MARK: Dictionary Equatability

public func == <Key, Value: Equatable> (lhs: Expectation<[Key: Value]>, rhs: [Key: Value]) throws {
  if let value = try lhs.expression() {
    if value != rhs {
      throw lhs.failure("\(String(describing: value)) is not equal to \(rhs)")
    }
  } else {
    throw lhs.failure("given value is nil")
  }
}

public func != <Key, Value: Equatable> (lhs: Expectation<[Key: Value]>, rhs: [Key: Value]) throws {
  if let value = try lhs.expression() {
    if value == rhs {
      throw lhs.failure("\(String(describing: value)) is equal to \(rhs)")
    }
  } else {
    throw lhs.failure("given value is nil")
  }
}

// MARK: Nil

extension ExpectationType {
  public func beNil() throws {
    let value = try expression()
    if value != nil {
      throw failure("value is not nil")
    }
  }
}

// MARK: Boolean

extension ExpectationType where ValueType == Bool {
  public func beTrue() throws {
    let value = try expression()
    if value != true {
      throw failure("value is not true")
    }
  }

  public func beFalse() throws {
    let value = try expression()
    if value != false {
      throw failure("value is not false")
    }
  }
}

// Mark: Types

extension ExpectationType {
  public func beOfType(_ expectedType: Any.Type) throws {
    guard let value = try expression() else { throw failure("cannot determine type: expression threw an error or value is nil") }
    let valueType = Mirror(reflecting: value).subjectType
    if valueType != expectedType {
      throw failure("'\(valueType)' is not the expected type '\(expectedType)'")
    }
  }
}

// MARK: Error Handling

extension ExpectationType {
  public func toThrow() throws {
    var didThrow = false

    do {
      _ = try expression()
    } catch {
      didThrow = true
    }

    if !didThrow {
      throw failure("expression did not throw an error")
    }
  }

  public func toThrow<T: Equatable>(_ error: T) throws {
    var thrownError: Error? = nil

    do {
      _ = try expression()
    } catch {
      thrownError = error
    }

    if let thrownError = thrownError {
      if let thrownError = thrownError as? T {
        if error != thrownError {
          throw failure("\(thrownError) is not \(error)")
        }
      } else {
        throw failure("\(thrownError) is not \(error)")
      }
    } else {
      throw failure("expression did not throw an error")
    }
  }
}

// MARK: Comparable

public func > <E: ExpectationType>(lhs: E, rhs: E.ValueType) throws where E.ValueType: Comparable {
  let value = try lhs.expression()
  guard value! > rhs else {
    throw lhs.failure("\(String(describing: value)) is not more than \(rhs)")
  }
}

public func >= <E: ExpectationType>(lhs: E, rhs: E.ValueType) throws where E.ValueType: Comparable {
  let value = try lhs.expression()
  guard value! >= rhs else {
    throw lhs.failure("\(String(describing: value)) is not more than or equal to \(rhs)")
  }
}

public func < <E: ExpectationType>(lhs: E, rhs: E.ValueType) throws where E.ValueType: Comparable {
  let value = try lhs.expression()
  guard value! < rhs else {
    throw lhs.failure("\(String(describing: value)) is not less than \(rhs)")
  }
}

public func <= <E: ExpectationType>(lhs: E, rhs: E.ValueType) throws where E.ValueType: Comparable {
  let value = try lhs.expression()
  guard value! <= rhs else {
    throw lhs.failure("\(String(describing: value)) is not less than or equal to \(rhs)")
  }
}
