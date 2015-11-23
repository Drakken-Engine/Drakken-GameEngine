//
// Created by Allison Lindner on 09/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd
import CoreGraphics

public class Vector2D {
	public var x: Float
	public var y: Float

	public var float2: simd.float2 {
		get {
			return simd.float2(x, y)
		}
		set {
			self.x = newValue.x
			self.y = newValue.y
		}
	}

	public var CGVector: CoreGraphics.CGVector {
		get {
			return CGVectorMake(CGFloat(self.x), CGFloat(self.y))
		}
		set {
			self.x = Float(newValue.dx)
			self.y = Float(newValue.dy)
		}
	}

	public var CGPoint: CoreGraphics.CGPoint {
		get {
			return CGPointMake(CGFloat(self.x), CGFloat(self.y))
		}
		set {
			self.x = Float(newValue.x)
			self.y = Float(newValue.y)
		}
	}

	public var x_i: Int {
		get {
			return Int(self.x)
		}
		set {
			self.x = Float(newValue)
		}
	}

	public var y_i: Int {
		get {
			return Int(self.y)
		}
		set {
			self.y = Float(newValue)
		}
	}

	public init(_ x: Float, _ y: Float) {
		self.x = x
		self.y = y
	}
}