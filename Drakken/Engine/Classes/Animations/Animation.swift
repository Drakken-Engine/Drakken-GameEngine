//
// Created by Allison Lindner on 11/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import UIKit

public class Animation {
	private var _name: String

	private var _stepTime: Float
	var stepTime: Float {
		return _stepTime
	}

	private var _animationSequence: [Int]
	private var _mode: AnimationMode

	// - - - Internal Control - - -

	private var _currentFrameIndex: Int
	private var _repeatTimes: Int
	private var _currentRepeat: Int

	public init(name: String,
		 stepTime: Float,
		 mode: AnimationMode,
		 sequence: [Int])
	{
		_name = name
		_stepTime = stepTime
		_animationSequence = sequence
		_mode = mode

		_currentFrameIndex = 0
		_repeatTimes = 1
		_currentRepeat = 0
	}

	public convenience init(name: String,
					 stepFrames: Int,
					 targetFrameRate: Int,
					 mode: AnimationMode,
					 sequence: [Int],
					 completion: () -> ())
	{
		let stepTime = Float(stepFrames)/Float(targetFrameRate)
		self.init(name: name, stepTime: stepTime, mode: mode, sequence: sequence)
	}

	public func run(repeatTimes: Int) {
		_repeatTimes = repeatTimes
		_currentFrameIndex = 0
	}

	public func nextFrame(inout currentFrameIndex: Int) -> Bool {
		currentFrameIndex++
		if currentFrameIndex >= _animationSequence.count {
			if _mode == AnimationMode.Normal && _currentRepeat >= _repeatTimes - 1 {
				currentFrameIndex = _animationSequence.count - 1
				return false
			} else {
				currentFrameIndex = 0
				_currentRepeat++
				return true
			}
		}
		return true
	}

	public func getFrame(index: Int) -> Int {
		return _animationSequence[index]
	}
}
