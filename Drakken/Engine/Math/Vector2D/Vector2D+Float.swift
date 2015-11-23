//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Float
// MARK:	Vector2D + Float
public func + (vector: Vector2D, scalar: Float) -> Vector2D {
	return Vector2D(vector.x + scalar, vector.y + Float(scalar))
}

// MARK:	Float + Vector2D
public func + (scalar: Float, vector: Vector2D) -> Vector2D {
	return Vector2D(scalar + vector.x, scalar + vector.y)
}

// MARK:	Vector2D += Float
public func += (inout vector: Vector2D, scalar: Float) {
	vector = vector + scalar
}

// MARK:	Vector2D - Float
public func - (vector: Vector2D, scalar: Float) -> Vector2D {
	return Vector2D(vector.x - scalar, vector.y - Float(scalar))
}

// MARK:	Float - Vector2D
public func - (scalar: Float, vector: Vector2D) -> Vector2D {
	return Vector2D(scalar - vector.x, scalar - vector.y)
}

// MARK:	Vector2D -= Float
public func -= (inout vector: Vector2D, scalar: Float) {
	vector = vector - scalar
}

// MARK:	Vector2D * Float
public func * (vector: Vector2D, scalar: Float) -> Vector2D {
	return Vector2D(vector.x * scalar, vector.y * Float(scalar))
}

// MARK:	Float * Vector2D
public func * (scalar: Float, vector: Vector2D) -> Vector2D {
	return Vector2D(scalar * vector.x, scalar * vector.y)
}

// MARK:	Vector2D *= Float
public func *= (inout vector: Vector2D, scalar: Float) {
	vector = vector * scalar
}

// MARK:	Vector2D / Float
public func / (vector: Vector2D, scalar: Float) -> Vector2D {
	return Vector2D(vector.x / scalar, vector.y / Float(scalar))
}

// MARK:	Float / Vector2D
public func / (scalar: Float, vector: Vector2D) -> Vector2D {
	return Vector2D(scalar / vector.x, scalar / vector.y)
}

// MARK:	Vector2D /= Float
public func /= (inout vector: Vector2D, scalar: Float) {
	vector = vector / scalar
}