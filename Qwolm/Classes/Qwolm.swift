//
//  Qwolm.swift
//
//  Created by Mikhail Akopov on 18/11/2017.
//

public final class Qwolm<Input: Equatable, Output: Any> {
    
    public typealias Completion = (Output) -> Void
    public typealias Task = (Input, @escaping Completion) -> Void

    private var executing: Bool = false
    private var nextInput: Input? = nil

    private let task: Task
    private let taskQueue = DispatchQueue(label: "ru.mikhail-akopov.qwolm" + UUID().uuidString)

    private let completion: Completion
    private let completionQueue: DispatchQueue

    public var omitPreviousOutput: Bool

    required public init(task: @escaping Task,  completionQueue: DispatchQueue = .main, omitPreviousOutput: Bool = true, completion: @escaping Completion) {
        self.task = task
        self.omitPreviousOutput = omitPreviousOutput
        self.completionQueue = completionQueue
        self.completion = completion
    }

    public func execute(input: Input) {

        if executing {
            nextInput = input
            return
        }
        executing = true

        taskQueue.async { [weak self] in

            self?.task(input) { output in

                self?.completionQueue.async {
                    self?.executionWithInput(input, didCompleteWithOutput: output)
                }
            }
        }
    }

    private func executionWithInput(_ input: Input, didCompleteWithOutput output: Output) {
        executing = false

        if let nextInput = self.nextInput, nextInput != input {

            if !omitPreviousOutput {
                completion(output)
            }
            execute(input: nextInput)
            
        } else {
            completion(output)
        }

        self.nextInput = nil
    }

}
