== Core Data vs. Sqlite

Since there are absolutely no benchmarks on sqlite vs. core data for the iphone, I figured I'd create some.

== Running

1. open xcode project
2. select CoreDataVsSqliteTests + iPhoneSimulator
3. Run tests by pressing CMD+U
4. CMD-SHIFT-C to see test results

== Caveats / Bugs

- this uses ARC - so it may not apply to your situation
- this also uses fmdb - no idea what the overhead is vs. raw C sqlite db access
