#if os(Linux)
import Glibc
#else
import Darwin
#endif


let globalContext: GlobalContext = {
  // atexit { run() }
  return GlobalContext()
}()

public func describe(_ name: String, closure: (ContextType) -> Void) {
  globalContext.describe(name, closure: closure)
}

public func it(_ name: String, closure: @escaping () throws -> Void) {
  globalContext.it(name, closure: closure)
}

public func run() -> Never  {
  let reporter: Reporter

  if CommandLine.arguments.contains("--tap") {
    reporter = TapReporter()
  } else if CommandLine.arguments.contains("-t") {
    reporter = DotReporter()
  } else {
    reporter = StandardReporter()
  }

  run(reporter: reporter)
}

public func run(reporter: Reporter) -> Never  {
  if globalContext.run(reporter: reporter) {
    exit(0)
  }
  exit(1)
}
