class GlobalContext {
  var cases = [CaseType]()

  func describe(_ name: String, closure: (ContextType) -> Void) {
    let context = Context(name: name)
    closure(context)
    cases.append(context)
  }

  func it(_ name: String, closure: @escaping () throws -> Void) {
    cases.append(Case(name: name, closure: closure))
  }

  func run(reporter: Reporter) -> Bool {
    return reporter.report { reporter in
      for `case` in cases {
        `case`.run(reporter: reporter)
      }
    }
  }
}
