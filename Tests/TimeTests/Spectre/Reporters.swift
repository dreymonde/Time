import Foundation
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif


enum ANSI : String, CustomStringConvertible {
  case Red = "\u{001B}[0;31m"
  case Green = "\u{001B}[0;32m"
  case Yellow = "\u{001B}[0;33m"

  case Bold = "\u{001B}[0;1m"
  case Reset = "\u{001B}[0;0m"

  static var supportsANSI: Bool {
    guard isatty(STDOUT_FILENO) != 0 else {
      return false
    }

    guard let termType = getenv("TERM") else {
      return false
    }

    guard String(cString: termType).lowercased() != "dumb" else {
      return false
    }

    return true
  }

  var description: String {
    if ANSI.supportsANSI {
      return rawValue
    }

    return ""
  }
}


struct CaseFailure {
  let position: [String]
  let failure: FailureType

  init(position: [String], failure: FailureType) {
    self.position = position
    self.failure = failure
  }
}


fileprivate func stripCurrentDirectory(_ file: String) -> String {
  var currentPath = FileManager.`default`.currentDirectoryPath
  if !currentPath.hasSuffix("/") {
    currentPath += "/"
  }

  if file.hasPrefix(currentPath) {
    return String(file.suffix(from: currentPath.endIndex))
  }

  return file
}


func printFailures(_ failures: [CaseFailure]) {
  for failure in failures {
    let name = failure.position.joined(separator: " ")
    Swift.print(ANSI.Red, name)

    let file = "\(stripCurrentDirectory(failure.failure.file)):\(failure.failure.line)"
    Swift.print("  \(ANSI.Bold)\(file)\(ANSI.Reset) \(ANSI.Yellow)\(failure.failure.reason)\(ANSI.Reset)\n")

    if let contents = try? String(contentsOfFile: failure.failure.file, encoding: String.Encoding.utf8) as String {
      let lines = contents.components(separatedBy: CharacterSet.newlines)
      let line = lines[failure.failure.line - 1]
      let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespaces)
      Swift.print("  ```")
      Swift.print("  \(trimmedLine)")
      Swift.print("  ```")
    }
  }
}


class CountReporter : Reporter, ContextReporter {
  var depth = 0
  var successes = 0
  var disabled = 0
  var position = [String]()
  var failures = [CaseFailure]()

  func printStatus() {
    printFailures(failures)

    let disabledMessage: String
    if disabled > 0 {
      disabledMessage = " \(disabled) skipped,"
    } else {
      disabledMessage = ""
    }

    if failures.count == 1 {
      print("\(successes) passes\(disabledMessage) and \(failures.count) failure")
    } else {
      print("\(successes) passes\(disabledMessage) and \(failures.count) failures")
    }
  }

#if swift(>=3.0)
  func report(closure: (ContextReporter) -> Void) -> Bool {
    closure(self)
    printStatus()
    return failures.isEmpty
  }
#else
  func report(@noescape _ closure: (ContextReporter) -> Void) -> Bool {
    closure(self)
    printStatus()
    return failures.isEmpty
  }
#endif

#if swift(>=3.0)
  func report(_ name: String, closure: (ContextReporter) -> Void) {
    depth += 1
    position.append(name)
    closure(self)
    depth -= 1
    position.removeLast()
  }
#else
  func report(_ name: String, @noescape closure: (ContextReporter) -> Void) {
    depth += 1
    position.append(name)
    closure(self)
    depth -= 1
    position.removeLast()
  }
#endif

  func addSuccess(_ name: String) {
    successes += 1
  }

  func addDisabled(_ name: String) {
    disabled += 1
  }

  func addFailure(_ name: String, failure: FailureType) {
    failures.append(CaseFailure(position: position + [name], failure: failure))
  }
}


/// Standard reporter
class StandardReporter : CountReporter {
  override func report(_ name: String, closure: (ContextReporter) -> Void) {
    colour(.Bold, "-> \(name)")
    super.report(name, closure: closure)
    print("")
  }

  override func addSuccess(_ name: String) {
    super.addSuccess(name)
    colour(.Green, "-> \(name)")
  }

  override func addDisabled(_ name: String) {
    super.addDisabled(name)
    colour(.Yellow, "-> \(name)")
  }

  override func addFailure(_ name: String, failure: FailureType) {
    super.addFailure(name, failure: failure)
    colour(.Red, "-> \(name)")
  }

  func colour(_ colour: ANSI, _ message: String) {
    let indentation = String(repeating: " ", count: depth * 2)
    print("\(indentation)\(colour)\(message)\(ANSI.Reset)")
  }
}


/// Simple reporter that outputs minimal . F and S.
class DotReporter : CountReporter {
  override func addSuccess(_ name: String) {
    super.addSuccess(name)
    print(ANSI.Green, ".", ANSI.Reset, separator: "", terminator: "")
  }

  override func addDisabled(_ name: String) {
    super.addDisabled(name)
    print(ANSI.Yellow, "S", ANSI.Reset, separator: "", terminator: "")
  }

  override func addFailure(_ name: String, failure: FailureType) {
    super.addFailure(name, failure: failure)
    print(ANSI.Red, "F", ANSI.Reset, separator: "", terminator: "")
  }

  override func printStatus() {
    print("\n")
    super.printStatus()
  }
}


/// Test Anything Protocol compatible reporter
/// http://testanything.org
class TapReporter : CountReporter {
  var count = 0

  override func addSuccess(_ name: String) {
    count += 1
    super.addSuccess(name)

    let message = (position + [name]).joined(separator: " ")
    print("ok \(count) - \(message)")
  }

  override func addDisabled(_ name: String) {
    count += 1
    super.addDisabled(name)

    let message = (position + [name]).joined(separator: " ")
    print("ok \(count) - # skip \(message)")
  }

  override func addFailure(_ name: String, failure: FailureType) {
    count += 1
    super.addFailure(name, failure: failure)

    let message = (position + [name]).joined(separator: " ")
    print("not ok \(count) - \(message)")
    print("# \(failure.reason) from \(stripCurrentDirectory(failure.file)):\(failure.line)")
  }

  override func printStatus() {
    print("\(min(1, count))..\(count)")
  }
}
