# Core Data vs. Sqlite

For the very first time ever:

benchmarks of core data vs. sqlite

## Caveats / Bugs

* this uses ARC - so it may not apply to your situation
* this also uses fmdb - no idea what the overhead is vs. raw C sqlite3 db access
* benchmarks aren't that complicated + table data isn't randomized

## Running

1. git submodule update --init
1. open CoreDataVsSqlLite.xcodeproj
1. select CoreDataVsSqliteView + iPhone (or iPhone Simulator)
1. Run it
1. Output is in debugger window (CMD-C to view)
1. When benchmarks are done, you should see a white screen on the iphoen

### My results: - iPhone 4g

    2012-02-07 14:59:33.332 CoreDataVsSqliteView[5395:707]
    2012-02-07 14:59:33.336 CoreDataVsSqliteView[5395:707] --- starting benchmark: inserting 1000 records with sqlite ---
    2012-02-07 14:59:41.667 CoreDataVsSqliteView[5395:707] --- completed benchmark: inserting 1000 records with sqlite, time: 8.329158 ---
    2012-02-07 14:59:41.708 CoreDataVsSqliteView[5395:707]
    2012-02-07 14:59:41.710 CoreDataVsSqliteView[5395:707] --- starting benchmark: inserting 1000 records with core data ---
    2012-02-07 15:00:02.065 CoreDataVsSqliteView[5395:707] --- completed benchmark: inserting 1000 records with core data, time: 20.353644 ---
    2012-02-07 15:00:02.067 CoreDataVsSqliteView[5395:707]
    2012-02-07 15:00:02.070 CoreDataVsSqliteView[5395:707] --- starting benchmark: selecting all records with sqlite, users table ---
    2012-02-07 15:00:02.095 CoreDataVsSqliteView[5395:707] fetchResults count: 1000
    2012-02-07 15:00:31.797 CoreDataVsSqliteView[5395:707] --- completed benchmark: selecting all records with sqlite, users table, time: 29.725567 ---
    2012-02-07 15:00:31.799 CoreDataVsSqliteView[5395:707]
    2012-02-07 15:00:31.800 CoreDataVsSqliteView[5395:707] --- starting benchmark: query all core data ---
    2012-02-07 15:00:31.825 CoreDataVsSqliteView[5395:707] fetchResults count: 1000
    2012-02-07 15:00:51.056 CoreDataVsSqliteView[5395:707] --- completed benchmark: query all core data, time: 19.253524 ---
    2012-02-07 15:00:51.057 CoreDataVsSqliteView[5395:707]
    2012-02-07 15:00:51.059 CoreDataVsSqliteView[5395:707] --- starting benchmark: selecting id records with sqlite, users table ---
    2012-02-07 15:00:51.061 CoreDataVsSqliteView[5395:707] fetchResults count: 1
    2012-02-07 15:00:51.604 CoreDataVsSqliteView[5395:707] --- completed benchmark: selecting id records with sqlite, users table, time: 0.543719 ---
    2012-02-07 15:00:51.606 CoreDataVsSqliteView[5395:707]
    2012-02-07 15:00:51.607 CoreDataVsSqliteView[5395:707] --- starting benchmark: query ids - core data ---
    2012-02-07 15:00:51.612 CoreDataVsSqliteView[5395:707] fetchResults count: 1
    2012-02-07 15:00:52.883 CoreDataVsSqliteView[5395:707] --- completed benchmark: query ids - core data, time: 1.274649 ---


## Other useful reading:

http://cocoawithlove.com/2010/02/differences-between-core-data-and.html
http://cocoawithlove.com/2008/03/testing-core-data-with-very-big.html