# Qwolm

![Swift Version](https://img.shields.io/badge/Swift-4.0-green.svg)
[![Platform](https://img.shields.io/cocoapods/p/Qwolm.svg?style=flat)](http://cocoapods.org/pods/Qwolm)
[![Version](https://img.shields.io/cocoapods/v/Qwolm.svg?style=flat)](http://cocoapods.org/pods/Qwolm)
[![CI Status](http://img.shields.io/travis/wacumov/Qwolm.svg?style=flat)](https://travis-ci.org/wacumov/Qwolm)
[![codebeat badge](https://codebeat.co/badges/7b09701c-d1fd-44e8-8576-48f860817392)](https://codebeat.co/projects/github-com-wacumov-qwolm-master)

A simple utility for handling cases when:
- new calls of a long-running task may arrive before it is completed;
- only the result of the last call matters.

## Usage

``` swift
class SomeClass {

	// Define input and output types
	private var qwolm: Qwolm<Int, Int>!

	init() {
		// Initialize with a task and a completion handler
		qwolm = Qwolm(task: complexTask) { output in
			print(output)
		}
	}

	// This function gets called very often
	func execute(input: Int) {
		qwolm.execute(input: input)
	}

	// A difficult task that takes a long time
	private func complexTask(input: Int, completion: @escaping (Int) -> Void) {
		let output = input + 1
		completion(output)
	}

}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Qwolm is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your `Podfile`:

```ruby
pod 'Qwolm'
```

Then run `pod install`.

## Author

Mikhail Akopov, mikhail.akopov@aol.com

## License

Qwolm is available under the MIT license. See the LICENSE file for more info.
