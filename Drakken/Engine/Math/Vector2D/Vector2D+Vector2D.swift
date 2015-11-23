//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Vector2D
// MARK:	Vector2D == Vector2D
public func == (left: Vector2D, right: Vector2D) -> Bool {
	return (left.x == right.x) && (left.y == right.y)
}

// MARK:	Vector2D != Vector2D
public func != (left: Vector2D, right: Vector2D) -> Bool {
	return !(left == right)
}

// MARK:	Vector2D + Vector2D
public func + (left: Vector2D, right: Vector2D) -> Vector2D {
	return Vector2D(left.x + right.x, left.y + right.y)
}

// MARK:	Vector += Vector2D
public func += (inout vec1: Vector2D, vec2: Vector2D) {
	vec1 = vec1 + vec2
}

// MARK:	Vector2D - Vector2D
public func - (left: Vector2D, right: Vector2D) -> Vector2D {
	return Vector2D(left.x - right.x, left.y - right.y)
}

// MARK:	Vector -= Vector2D
public func -= (inout vec1: Vector2D, vec2: Vector2D) {
	vec1 = vec1 - vec2
}

// MARK:	-Vector2D
public prefix func - (vector: Vector2D) -> Vector2D {
	return Vector2D(-vector.x, -vector.y)
}

// MARK:	Vector2D * Vector2D
public func * (left: Vector2D, right: Vector2D) -> Vector2D {
	return Vector2D(left.x * right.x, left.y * right.y)
}

// MARK:	Vector *= Vector2D
public func *= (inout vec1: Vector2D, vec2: Vector2D) {
	vec1 = vec1 * vec2
}

// MARK:	Vector2D / Vector2D
public func / (left: Vector2D, right: Vector2D) -> Vector2D {
	return Vector2D(left.x / right.x, left.y / right.y)
}

// MARK:	Vector /= Vector2D
public func /= (inout vec1: Vector2D, vec2: Vector2D) {
	vec1 = vec1 / vec2
}