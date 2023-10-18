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
//		print("\(j2000_utc.toDate(from: .utc))")

		// The J2000 epoch is 12:00:00 TT on 1 January, 2000
		let j2000_tt = CAADate(2000, 1, 1, 12, 0, 0, true)
//		print("\(j2000_tt.toDate(from: .tt))")

		let j2000_utc_tt = CAADynamicalTime.UTC2TT(j2000_utc.Julian())
		let j2000_tt_utc = CAADynamicalTime.TT2UTC(j2000_tt.Julian())

		XCTAssert(j2000_utc_tt == j2000_tt.Julian())
		XCTAssert(j2000_tt_utc == j2000_utc.Julian())
	}

	func testDate() {
		// The Unix epoch is 00:00:00 UTC on 1 January, 1970
		let unixEpoch = CAADate(1970, 1, 1, true)
//		print("\(unixEpoch.toDate(from: .utc))")
		XCTAssert(unixEpoch.InGregorianCalendar())
		XCTAssert(unixEpoch.Year() == 1970)
		XCTAssert(unixEpoch.Month() == 1)
		XCTAssert(unixEpoch.Day() == 1)
		XCTAssert(unixEpoch.Hour() == 0)
		XCTAssert(unixEpoch.Minute() == 0)
		XCTAssert(unixEpoch.Second() == 0)
		XCTAssert(unixEpoch.Julian() == unixEpoch_UTC)
	}
#endif
}

#if swift(>=5.9)
/// The number of seconds in one day.
let secondsPerDay: Double = 60 * 60 * 24
/// The Julian date in UTC corresponding to the Unix epoch.
/// - note: The Unix epoch is 00:00:00 UTC on 1 January 1970.
let unixEpoch_UTC = 2440587.5

/// Common time frames used in astronomy,
enum TimeFrame {
	/// Coordinated Universal Time (UTC).
	case utc
	/// Terrestrial Time (TT).
	case tt
}

extension Date {
	/// Creates a date value initialized to the specified Julian date in UTC.
	init(julianDate: Double) {
		self.init(timeIntervalSince1970: (julianDate - unixEpoch_UTC) * secondsPerDay)
	}

	/// Returns the Julian date in UTC corresponding to `self`.
	public var julianDate: Double {
		timeIntervalSince1970 / secondsPerDay + unixEpoch_UTC
	}

	/// Converts `self` to a `CAADate` instance
	func toCAADate() -> CAADate {
		let jd = julianDate
		return CAADate(jd, CAADate.AfterPapalReform(jd))
	}
}

extension CAADate {
	/// Converts the date represented by `self` in `timeFrame` to a `Date` instance
	func toDate(from timeFrame: TimeFrame) -> Date {
		switch timeFrame {
		case .utc:
			return Date(julianDate: Julian())
		case .tt:
			return Date(julianDate: CAADynamicalTime.TT2UTC(Julian()))
		}
	}
}

#endif
