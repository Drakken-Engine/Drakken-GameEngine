//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Int
// MARK:	Vector2D + Int
public func + (vector: Vector2D, scalar: Int) -> Vector2D {
	return Vector2D(vector.x + Float(scalar), vector.y + Float(scalar))
}

// MARK:	Int + Vector2D
public func + (scalar: Int, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) + vector.x, Float(scalar) + vector.y)
}

// MARK:	Vector2D += Int
public func += (inout vector: Vector2D, scalar: Int) {
	vector = vector + scalar
}

// MARK:	Vector2D - Int
public func - (vector: Vector2D, scalar: Int) -> Vector2D {
	return Vector2D(vector.x - Float(scalar), vector.y - Float(scalar))
}

// MARK:	Int - Vector2D
public func - (scalar: Int, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) - vector.x, Float(scalar) - vector.y)
}

// MARK:	Vector2D -= Int
public func -= (inout vector: Vector2D, scalar: Int) {
	vector = vector - scalar
}

// MARK:	Vector2D * Int
public func * (vector: Vector2D, scalar: Int) -> Vector2D {
	return Vector2D(vector.x * Float(scalar), vector.y * Float(scalar))
}

// MARK:	Int * Vector2D
public func * (scalar: Int, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) * vector.x, Float(scalar) * vector.y)
}

// MARK:	Vector2D *= Int
public func *= (inout vector: Vector2D, scalar: Int) {
	vector = vector * scalar
}

// MARK:	Vector2D / Int
public func / (vector: Vector2D, scalar: Int) -> Vector2D {
	return Vector2D(vector.x / Float(scalar), vector.y / Float(scalar))
}

// MARK:	Int / Vector2D
public func / (scalar: Int, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(scalar) / vector.x, Float(scalar) / vector.y)
}

// MARK:	Vector2D /= Int
public func /= (inout vector: Vector2D, scalar: Int) {
	vector = vector / scalar
}