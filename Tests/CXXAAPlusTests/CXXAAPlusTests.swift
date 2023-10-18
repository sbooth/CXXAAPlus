//
// Copyright © 2021-2023 Stephen F. Booth <me@sbooth.org>
// Part of https://github.com/sbooth/CXXAAPlus
// MIT license
//

import XCTest
@testable import CXXAAPlus

final class CXXAAPlusTests: XCTestCase {
#if swift(>=5.9)
	func testDynamicalTime() {
		// The J2000 epoch is 11:58:55.816 UTC on 1 January, 2000.
		let j2000_utc = CAADate(2000, 1, 1, 11, 58, 55.816, true)

		// The J2000 epoch is 12:00:00 TT on 1 January, 2000
		let j2000_tt = CAADate(2000, 1, 1, 12, 0, 0, true)

		let j2000_utc_tt = CAADynamicalTime.UTC2TT(j2000_utc.Julian())
		let j2000_tt_utc = CAADynamicalTime.TT2UTC(j2000_tt.Julian())

		XCTAssert(j2000_utc_tt == j2000_tt.Julian())
		XCTAssert(j2000_tt_utc == j2000_utc.Julian())
	}

	func testDate() {
		// The Unix epoch is 00:00:00 UTC on 1 January, 1970
		let unixEpoch = CAADate(1970, 1, 1, true)
		XCTAssert(unixEpoch.InGregorianCalendar())
		XCTAssert(unixEpoch.Year() == 1970)
		XCTAssert(unixEpoch.Month() == 1)
		XCTAssert(unixEpoch.Day() == 1)
		XCTAssert(unixEpoch.Hour() == 0)
		XCTAssert(unixEpoch.Minute() == 0)
		XCTAssert(unixEpoch.Second() == 0)
		XCTAssert(unixEpoch.Julian() == 2440587.5)
	}
#endif
}
