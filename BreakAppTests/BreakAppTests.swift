//
//  BreakAppTests.swift
//  BreakAppTests
//
//  Created by Nishant Gulani on 26/02/26.
//

import Testing
@testable import BreakApp

struct BreakSessionModelTests {

    @Test func remainingSeconds_isPositive_whenNotExpired() {
        let session = BreakSession(
            startTime: Date(),
            durationSeconds: 300,
            userId: "user1",
            endedEarly: false,
            actualEndTime: nil
        )
        #expect(session.remainingSeconds > 0)
        #expect(!session.isExpired)
    }

    @Test func remainingSeconds_isZero_whenExpired() {
        let session = BreakSession(
            startTime: Date().addingTimeInterval(-600),
            durationSeconds: 300,
            userId: "user1",
            endedEarly: false,
            actualEndTime: nil
        )
        #expect(session.remainingSeconds == 0)
        #expect(session.isExpired)
    }

    @Test func isExpired_whenEndedEarly() {
        let session = BreakSession(
            startTime: Date(),
            durationSeconds: 300,
            userId: "user1",
            endedEarly: true,
            actualEndTime: Date()
        )
        #expect(session.isExpired)
    }

    @Test func endTime_isStartPlusDuration() {
        let start = Date()
        let session = BreakSession(
            startTime: start,
            durationSeconds: 300,
            userId: "user1",
            endedEarly: false,
            actualEndTime: nil
        )
        let expected = start.addingTimeInterval(300)
        #expect(abs(session.endTime.timeIntervalSince(expected)) < 1)
    }
}
