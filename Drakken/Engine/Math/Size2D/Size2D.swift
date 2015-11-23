//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd
import CoreGraphics

public class Size2D {
	public var width: Float
	public var height: Float

	public var float2: simd.float2 {
		get {
			return simd.float2(width, height)
		}
		set {
			width = newValue.x
			height = newValue.y
		}
	}

	public var CGSize: CoreGraphics.CGSize {
		get {
			return CGSizeMake(CGFloat(width), CGFloat(height))
		}
		set {
			width = Float(newValue.width)
			height = Float(newValue.height)
		}
	}

	public var width_i: Int {
		get {
			return Int(width)
		}
		set {
			width = Float(newValue)
		}
	}

	public var height_i: Int {
		get {
			return Int(height)
		}
		set {
			height = Float(newValue)
		}
	}

	public init(_ width: Float, _ height: Float) {
		self.width = width
		self.height = height
	}

	public convenience init(_ width: Int, _ height: Int) {
		self.init(Float(width), Float(height))
	}

	public convenience init(_ width: UInt32, _ height: UInt32) {
		self.init(Float(width), Float(height))
	}
}