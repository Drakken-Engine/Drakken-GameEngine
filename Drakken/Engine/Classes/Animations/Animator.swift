//
// Created by Allison Lindner on 11/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

public class Animator {
	private var _currentAnimationSheet: String?
	private var _currentAnimation: String?

	private var _animationSheets: [String: AnimationSheet]
	private var _animations: [String: Animation]

	private var _component: GameComponent?
	private var _iddleAnimationName: String
	private var _paused: Bool

	private var _currentTime: Float
	private var _stepTime: Float
	private var _currentFrameIndex: Int

	var _defaultTexture: Texture

	public init(_ component: GameComponent? = nil) {
		_animationSheets = [String: AnimationSheet]()
		_animations = [String: Animation]()
		_iddleAnimationName = ""
		_paused = false
		_defaultTexture = Texture(fileName: "black_pixel")

		_currentFrameIndex = 0
		_stepTime = 0.0
		_currentTime = 0.0

		if component != nil {
			_component = component
			_component!.animated = false
		}
	}

	internal func setComponent(component: GameComponent) {
		_component = component
		_component!.animated = false
	}

	public func setCurrentAnimationSheet(name: String) {
		_currentAnimationSheet = name
	}

	public func run(name: String, repeatTimes: Int = 1) {
		_animations[name]!.run(repeatTimes)
		_currentAnimation = name
		_stepTime = _animations[name]!.stepTime
		_currentFrameIndex = 0
		_currentTime = 0.0

		if _component != nil {
			_component!.animated = true
		}
	}

	public func stop() {
		if _iddleAnimationName != "" {
			_animations[_iddleAnimationName]!.run(1)
			_currentAnimation = _iddleAnimationName
		} else {
			_component?.animated = false
		}
	}

	public func pause() {
		_paused = true
	}

	public func play() {
		_paused = false
	}

	public func addAnimationSheet(name name: String, animationSheet: Texture, sliceSize: Size2D) {
		let animationSheet = AnimationSheet(name: name, animationSheet: animationSheet, sliceSize: sliceSize)

		_animationSheets.updateValue(animationSheet, forKey: name)
	}
	
	private func _newAnimation(name name: String,
							   stepTime: Float,
							   mode: AnimationMode,
							   sequence: [Int])
	{
		let animation = Animation(name: name, stepTime: stepTime, mode: mode, sequence: sequence)
		_animations.updateValue(animation, forKey: name)

		if mode == AnimationMode.Iddle {
			_iddleAnimationName = name
		}
	}
	
	public func newAnimation(name name: String,
					  stepTime: Float,
					  mode: AnimationMode,
					  sequence: [Int]...)
	{
		var array = [Int]()
		for var i = 0; i < sequence.count; i++ {
			for var j = 0; j < sequence[i].count; j++ {
				array.append(sequence[i][j])
			}
		}
		_newAnimation(name: name, stepTime: stepTime, mode: mode, sequence: array)
	}
	
	public func newAnimation(name name: String,
					  stepFrames: Int,
					  targetFrameRate: Int,
					  mode: AnimationMode,
					  sequence: [Int]...)
	{
		let stepTime = Float(stepFrames)/Float(targetFrameRate)
		var array = [Int]()
		for var i = 0; i < sequence.count; i++ {
			for var j = 0; j < sequence[i].count; j++ {
				array.append(sequence[i][j])
			}
		}
		_newAnimation(name: name, stepTime: stepTime, mode: mode, sequence: array)
	}

	public func newAnimation(name name: String,
					  stepTime: Float,
					  mode: AnimationMode,
					  sequence: Int...)
	{
		_newAnimation(name: name, stepTime: stepTime, mode: mode, sequence: sequence)
	}

	public func newAnimation(name name: String,
					  stepFrames: Int,
					  targetFrameRate: Int,
					  mode: AnimationMode,
					  sequence: Int...)
	{
		let stepTime = Float(stepFrames)/Float(targetFrameRate)
		_newAnimation(name: name, stepTime: stepTime, mode: mode, sequence: sequence)
	}

	public func getCurrentFrameTexture() -> Texture {
		if _component != nil {
			if _component!.animated {
				if let currentAnimationSheet = _currentAnimationSheet {
					if let currentAnimation = _currentAnimation {
						return _animationSheets[currentAnimationSheet]!.getTextureAtFrame(
							_animations[currentAnimation]!.getFrame(_currentFrameIndex)
						)
					}
				}
			} else if _iddleAnimationName != "" {
				run(_iddleAnimationName)
				if let currentAnimationSheet = _currentAnimationSheet {
					return _animationSheets[currentAnimationSheet]!.getTextureAtFrame(
						_animations[_iddleAnimationName]!.getFrame(_currentFrameIndex)
					)
				}
			}
		}

		return _defaultTexture
	}

	private func _finished() {
		if _component != nil {
			_component!.animated = false
			_component!.delete()
		}
	}

	internal func update(deltaTime: CFTimeInterval) {
		if !_paused {
			if let currentAnimation = _currentAnimation {
				_currentTime += Float(deltaTime)
				if _currentTime >= _stepTime {
					if !_animations[currentAnimation]!.nextFrame(&_currentFrameIndex) {
						_finished()
					}

					_currentTime = 0
				}
			}
		}
	}

	internal func copy() -> Animator {
		let animator = Animator(_component)

		animator._animationSheets = _animationSheets
		animator._animations = _animations

		animator._currentAnimation = _currentAnimation
		animator._currentAnimationSheet = _currentAnimationSheet

		animator._iddleAnimationName = _iddleAnimationName
		animator._paused = _paused
		animator._defaultTexture = _defaultTexture

		return animator
	}
}
