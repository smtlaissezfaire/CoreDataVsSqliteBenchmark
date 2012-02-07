# Core Data vs. Sqlite

Since there are absolutely no benchmarks on sqlite vs. core data for the iphone, I figured I'd create some.

## Caveats / Bugs

- nothing is really completed yet - and I'm tired (it's 5AM)
- this uses ARC - so it may not apply to your situation
- this also uses fmdb - no idea what the overhead is vs. raw C sqlite db access

## Running

1. open xcode project
2. select CoreDataVsSqliteView + iPhoneSimulator (or iPhone)
3. Run it
4. Output is in debugger window