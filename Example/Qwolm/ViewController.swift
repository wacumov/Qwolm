//
//  ViewController.swift
//  Qwolm
//
//  Created by Mikhail Akopov on 11/18/2017.
//  Copyright (c) 2017 Mikhail Akopov. All rights reserved.
//

import UIKit
import Qwolm

class ViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    private lazy var calculator: Qwolm<Double, Double> = Qwolm(task: complexCalculation) { [weak self] output in

        self?.resultLabel.text = "result = \(output)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }

    private func handleTouches(_ touches: Set<UITouch>) {

        guard let firstTouch = touches.first else {
            return
        }

        let touchPoint = firstTouch.location(in: view)

        let number = Double(touchPoint.x * touchPoint.y)

        numberLabel.text = String(number)
        resultLabel.text = "..?.."

        calculator.execute(input: number)
    }

    private func complexCalculation(_ number: Double, completion: @escaping (Double) -> Void) {

        let output = number/7 * sqrt(number) * sqrt(number/2)

        let delay = Double(arc4random_uniform(100))/100.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(output)
        }
    }

}
