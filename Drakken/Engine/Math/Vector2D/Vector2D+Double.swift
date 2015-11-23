//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Double
// MARK:	Vector2D + Double
public func + (vector: Vector2D, scalar: Double) -> Vector2D {
	return Vector2D(vector.x + Float(scalar), vector.y + Float(scalar))
}

// MARK:	Double + Vector2D
public func + (scalar: Double, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) + vector.x, Float(scalar) + vector.y)
}

// MARK:	Vector2D += Double
public func += (inout vector: Vector2D, scalar: Double) {
	vector = vector + scalar
}

// MARK:	Vector2D - Double
public func - (vector: Vector2D, scalar: Double) -> Vector2D {
	return Vector2D(vector.x - Float(scalar), vector.y - Float(scalar))
}

// MARK:	Double - Vector2D
public func - (scalar: Double, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) - vector.x, Float(scalar) - vector.y)
}

// MARK:	Vector2D -= Double
public func -= (inout vector: Vector2D, scalar: Double) {
	vector = vector - scalar
}

// MARK:	Vector2D * Double
public func * (vector: Vector2D, scalar: Double) -> Vector2D {
	return Vector2D(vector.x * Float(scalar), vector.y * Float(scalar))
}

// MARK:	Double * Vector2D
public func * (scalar: Double, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) * vector.x, Float(scalar) * vector.y)
}

// MARK:	Vector2D *= Double
public func *= (inout vector: Vector2D, scalar: Double) {
	vector = vector * scalar
}

// MARK:	Vector2D / Double
public func / (vector: Vector2D, scalar: Double) -> Vector2D {
	return Vector2D(vector.x / Float(scalar), vector.y / Float(scalar))
}

// MARK:	Double / Vector2D
public func / (scalar: Double, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) / vector.x, Float(scalar) / vector.y)
}

// MARK:	Vector2D /= Double
public func /= (inout vector: Vector2D, scalar: Double) {
	vector = vector / scalar
}