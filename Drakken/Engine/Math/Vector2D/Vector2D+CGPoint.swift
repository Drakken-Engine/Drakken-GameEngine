//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK:	CGPoint
// MARK:	Vector2D + CGPoint
public func + (vector: Vector2D, cg_point: CGPoint) -> Vector2D {
	return Vector2D(vector.x + Float(cg_point.x), vector.y + Float(cg_point.y))
}

// MARK:	CGPoint + Vector2D
public func + (cg_point: CGPoint, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_point.x) + vector.x, Float(cg_point.y) + vector.y)
}

// MARK:	Vector2D += float2
public func += (inout vector: Vector2D, cg_point: CGPoint) {
	vector = vector + cg_point
}

// MARK:	Vector2D - CGPoint
public func - (vector: Vector2D, cg_point: CGPoint) -> Vector2D {
	return Vector2D(vector.x - Float(cg_point.x), vector.y - Float(cg_point.y))
}

// MARK:	CGPoint - Vector2D
public func - (cg_point: CGPoint, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_point.x) - vector.x, Float(cg_point.y) - vector.y)
}

// MARK:	Vector2D -= CGPoint
public func -= (inout vector: Vector2D, cg_point: CGPoint) {
	vector = vector - cg_point
}

// MARK:	Vector2D * CGPoint
public func * (vector: Vector2D, cg_point: CGPoint) -> Vector2D {
	return Vector2D(vector.x * Float(cg_point.x), vector.y * Float(cg_point.y))
}

// MARK:	CGPoint * Vector2D
public func * (cg_point: CGPoint, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_point.x) * vector.x, Float(cg_point.y) * vector.y)
}

// MARK:	Vector2D *= CGPoint
public func *= (inout vector: Vector2D, cg_point: CGPoint) {
	vector = vector * cg_point
}

// MARK:	Vector2D / CGPoint
public func / (vector: Vector2D, cg_point: CGPoint) -> Vector2D {
	return Vector2D(vector.x / Float(cg_point.x), vector.y / Float(cg_point.y))
}

// MARK:	CGPoint / Vector2D
public func / (cg_point: CGPoint, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_point.x) / vector.x, Float(cg_point.y) / vector.y)
}

// MARK:	Vector2D /= CGPoint
public func /= (inout vector: Vector2D, cg_point: CGPoint) {
	vector = vector / cg_point
}