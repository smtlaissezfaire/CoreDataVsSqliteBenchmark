# Core Data vs. Sqlite

For the very first time ever:

benchmarks of core data vs. sqlite

## Caveats / Bugs

* this uses ARC - so it may not apply to your situation
* this also uses fmdb - no idea what the overhead is vs. raw C sqlite3 db access
* benchmarks aren't that complicated + table data isn't randomized

## Running

- git submodule update --init
- open CoreDataVsSqlLite.xcodeproj
- select CoreDataVsSqliteView + iPhone (or iPhone Simulator)
- Run it
- Output is in debugger window (CMD-C to view)
- When benchmarks are done, you should see a white screen on the iphoen

### My results: - iPhone 4g

    2012-02-07 14:41:57.040 CoreDataVsSqliteView[5318:707]
    2012-02-07 14:41:57.043 CoreDataVsSqliteView[5318:707] --- starting benchmark: inserting 1000 records with sqlite ---
    2012-02-07 14:42:05.395 CoreDataVsSqliteView[5318:707] --- completed benchmark: inserting 1000 records with sqlite, time: 8.350023 ---
    2012-02-07 14:42:05.438 CoreDataVsSqliteView[5318:707]
    2012-02-07 14:42:05.439 CoreDataVsSqliteView[5318:707] --- starting benchmark: inserting 1000 records with core data ---
    2012-02-07 14:42:23.715 CoreDataVsSqliteView[5318:707] --- completed benchmark: inserting 1000 records with core data, time: 18.274596 ---
    2012-02-07 14:42:23.716 CoreDataVsSqliteView[5318:707]
    2012-02-07 14:42:23.717 CoreDataVsSqliteView[5318:707] --- starting benchmark: selecting all records with sqlite, users table ---
    2012-02-07 14:42:23.743 CoreDataVsSqliteView[5318:707] fetchResults count: 1000
    2012-02-07 14:42:53.925 CoreDataVsSqliteView[5318:707] --- completed benchmark: selecting all records with sqlite, users table, time: 30.206245 ---
    2012-02-07 14:42:53.926 CoreDataVsSqliteView[5318:707]
    2012-02-07 14:42:53.929 CoreDataVsSqliteView[5318:707] --- starting benchmark: query all core data ---
    2012-02-07 14:42:53.944 CoreDataVsSqliteView[5318:707] fetchResults count: 1000
    2012-02-07 14:43:13.258 CoreDataVsSqliteView[5318:707] --- completed benchmark: query all core data, time: 19.328316 ---
    2012-02-07 14:43:13.260 CoreDataVsSqliteView[5318:707]
    2012-02-07 14:43:13.261 CoreDataVsSqliteView[5318:707] --- starting benchmark: selecting id records with sqlite, users table ---
    2012-02-07 14:43:13.263 CoreDataVsSqliteView[5318:707] fetchResults count: 1
    2012-02-07 14:43:13.775 CoreDataVsSqliteView[5318:707] --- completed benchmark: selecting id records with sqlite, users table, time: 0.512242 ---
    2012-02-07 14:43:13.776 CoreDataVsSqliteView[5318:707]
    2012-02-07 14:43:13.778 CoreDataVsSqliteView[5318:707] --- starting benchmark: query ids - core data ---
    2012-02-07 14:43:13.784 CoreDataVsSqliteView[5318:707] fetchResults count: 1
    2012-02-07 14:43:16.412 CoreDataVsSqliteView[5318:707] --- completed benchmark: query ids - core data, time: 2.632413 ---

### My results: - iPhone Simulator

    2012-02-07 14:45:31.463 CoreDataVsSqliteView[76131:fb03]
    2012-02-07 14:45:31.464 CoreDataVsSqliteView[76131:fb03] --- starting benchmark: inserting 1000 records with sqlite ---
    2012-02-07 14:45:32.170 CoreDataVsSqliteView[76131:fb03] --- completed benchmark: inserting 1000 records with sqlite, time: 0.704847 ---
    2012-02-07 14:45:32.175 CoreDataVsSqliteView[76131:fb03]
    2012-02-07 14:45:32.176 CoreDataVsSqliteView[76131:fb03] --- starting benchmark: inserting 1000 records with core data ---
    2012-02-07 14:45:33.973 CoreDataVsSqliteView[76131:fb03] --- completed benchmark: inserting 1000 records with core data, time: 1.796568 ---
    2012-02-07 14:45:33.974 CoreDataVsSqliteView[76131:fb03]
    2012-02-07 14:45:33.974 CoreDataVsSqliteView[76131:fb03] --- starting benchmark: selecting all records with sqlite, users table ---
    2012-02-07 14:45:33.981 CoreDataVsSqliteView[76131:fb03] fetchResults count: 1000
    2012-02-07 14:45:36.555 CoreDataVsSqliteView[76131:fb03] --- completed benchmark: selecting all records with sqlite, users table, time: 2.580017 ---
    2012-02-07 14:45:36.556 CoreDataVsSqliteView[76131:fb03]
    2012-02-07 14:45:36.557 CoreDataVsSqliteView[76131:fb03] --- starting benchmark: query all core data ---
    2012-02-07 14:45:36.559 CoreDataVsSqliteView[76131:fb03] fetchResults count: 1000
    2012-02-07 14:45:38.745 CoreDataVsSqliteView[76131:fb03] --- completed benchmark: query all core data, time: 2.187561 ---
    2012-02-07 14:45:38.745 CoreDataVsSqliteView[76131:fb03]
    2012-02-07 14:45:38.746 CoreDataVsSqliteView[76131:fb03] --- starting benchmark: selecting id records with sqlite, users table ---
    2012-02-07 14:45:38.746 CoreDataVsSqliteView[76131:fb03] fetchResults count: 1
    2012-02-07 14:45:38.797 CoreDataVsSqliteView[76131:fb03] --- completed benchmark: selecting id records with sqlite, users table, time: 0.050612 ---
    2012-02-07 14:45:38.798 CoreDataVsSqliteView[76131:fb03]
    2012-02-07 14:45:38.798 CoreDataVsSqliteView[76131:fb03] --- starting benchmark: query ids - core data ---
    2012-02-07 14:45:38.799 CoreDataVsSqliteView[76131:fb03] fetchResults count: 1
    2012-02-07 14:45:39.097 CoreDataVsSqliteView[76131:fb03] --- completed benchmark: query ids - core data, time: 0.298490 ---
