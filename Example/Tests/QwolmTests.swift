import UIKit
import XCTest
@testable import Qwolm

private func delayWithSeconds(_ seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

private let heavyTaskExecutionTime = 1.0
private let shortInterval = 0.1

typealias TestInput = Int
typealias TestOutput = Int

private func heavyTask(input: TestInput, completion: @escaping (TestOutput) -> Void) {
    delayWithSeconds(heavyTaskExecutionTime) {
        completion(input)
    }
}

class QwolmTests: XCTestCase {

    var outputArray: [TestOutput]!
    var expectation: XCTestExpectation!
    var expectation2: XCTestExpectation!
    var quolm: Qwolm<TestInput, TestOutput>!

    override func setUp() {
        super.setUp()

        outputArray = []
        expectation = XCTestExpectation(description: "executed")
        expectation2 = XCTestExpectation(description: "waiting is complete")
        quolm = Qwolm(task: heavyTask) { [unowned self] output in
            self.outputArray.append(output)
            self.expectation.fulfill()
        }
    }

    func testExecute_Once_OneOutput() {
        // Given
        let testInput = 1

        // When
        quolm.execute(input: testInput)
        wait(for: [expectation], timeout: heavyTaskExecutionTime + shortInterval)

        // Then
        XCTAssert(outputArray.count == 1)
        XCTAssertEqual(outputArray.first, testInput)
    }

    func testExecute_TwiceWithSameInput_OneOutput() {
        // Given
        let inputArray = [1, 1]

        // When
        for input in inputArray {
            quolm.execute(input: input)
        }
        wait(for: [expectation], timeout: heavyTaskExecutionTime + shortInterval)

        // Then
        XCTAssert(outputArray.count == 1)
        XCTAssertEqual(outputArray.first, inputArray.first)
    }

    func testExecute_MultipleTimesWithDifferentInputWithSmallDelay_OneOutputWithLastValue() {
        // Given
        let inputArray = [1, 2, 3]

        let delay = heavyTaskExecutionTime/10

        // When
        for (index, input) in inputArray.enumerated() {
            delayWithSeconds(delay * Double(index)) {
                self.quolm.execute(input: input)
            }
        }
        wait(for: [expectation], timeout: heavyTaskExecutionTime * 2 + shortInterval)

        // Then
        XCTAssert(outputArray.count == 1)
        XCTAssertEqual(outputArray.last, inputArray.last)
    }

    func testExecute_TwiceWithDelayLessThanTaskExecutionTime_OneOutput() {
        // Given
        let inputArray = [1, 2]
        let delay = heavyTaskExecutionTime/2

        // When
        for (index, input) in inputArray.enumerated() {
            delayWithSeconds(delay * Double(index)) {
                self.quolm.execute(input: input)
            }
        }
        wait(for: [expectation], timeout: heavyTaskExecutionTime * 2 + shortInterval)

        // Then
        XCTAssert(outputArray.count == 1)
        XCTAssertEqual(outputArray.last, inputArray.last)
    }

    func testExecute_TwiceWithDelayMoreThanTaskExecutionTime_TwoOutputs() {
        // Given
        let inputArray = [1, 2]
        let delay = heavyTaskExecutionTime * 2

        // When
        for (index, input) in inputArray.enumerated() {
            delayWithSeconds(delay * Double(index)) {
                self.quolm.execute(input: input)
            }
        }
        wait(for: [expectation], timeout: heavyTaskExecutionTime + shortInterval)

        // Then
        XCTAssert(outputArray.count == 1)
        XCTAssertEqual(outputArray.first, inputArray.first)

        let waitingTime = heavyTaskExecutionTime * 2 + shortInterval
        delayWithSeconds(waitingTime) {
            XCTAssert(self.outputArray.count == 2)
            XCTAssertEqual(self.outputArray.last, inputArray.last)
            self.expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: waitingTime)
    }

    func testExecute_TwiceWithDelayLessThanTaskExecutionTimeButNotOmitPrevious_TwoOutputs() {
        // Given
        let inputArray = [1, 2]
        let delay = heavyTaskExecutionTime/2
        self.quolm.omitPreviousOutput = false

        // When
        for (index, input) in inputArray.enumerated() {
            delayWithSeconds(delay * Double(index)) {
                self.quolm.execute(input: input)
            }
        }
        wait(for: [expectation], timeout: heavyTaskExecutionTime * 2 + shortInterval)

        // Then
        XCTAssert(outputArray.count == 1)
        XCTAssertEqual(outputArray.first, inputArray.first)

        let waitingTime = heavyTaskExecutionTime * 2 + shortInterval
        delayWithSeconds(waitingTime) {
            XCTAssert(self.outputArray.count == 2)
            XCTAssertEqual(self.outputArray.last, inputArray.last)
            self.expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: waitingTime)
    }

}
