//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd

// MARK:	float2
// MARK:	Vector2D + float2
public func + (vector: Vector2D, float_2: float2) -> Vector2D {
	return Vector2D(vector.x + float_2.x, vector.y + float_2.y)
}

// MARK:	float2 + Vector2D
public func + (float_2: float2, vector: Vector2D) -> Vector2D {
	return Vector2D(float_2.x + vector.x, float_2.y + vector.y)
}

// MARK:	Vector2D += float2
public func += (inout vector: Vector2D, float_2: float2) {
	vector = vector + float_2
}

// MARK:	Vector2D - float2
public func - (vector: Vector2D, float_2: float2) -> Vector2D {
	return Vector2D(vector.x - float_2.x, vector.y - float_2.y)
}

// MARK:	float2 - Vector2D
public func - (float_2: float2, vector: Vector2D) -> Vector2D {
	return Vector2D(float_2.x - vector.x, float_2.y - vector.y)
}

// MARK:	Vector2D -= float2
public func -= (inout vector: Vector2D, float_2: float2) {
	vector = vector - float_2
}

// MARK:	Vector2D * float2
public func * (vector: Vector2D, float_2: float2) -> Vector2D {
	return Vector2D(vector.x * float_2.x, vector.y * float_2.y)
}

// MARK:	float2 * Vector2D
public func * (float_2: float2, vector: Vector2D) -> Vector2D {
	return Vector2D(float_2.x * vector.x, float_2.y * vector.y)
}

// MARK:	Vector2D *= float2
public func *= (inout vector: Vector2D, float_2: float2) {
	vector = vector * float_2
}

// MARK:	Vector2D / float2
public func / (vector: Vector2D, float_2: float2) -> Vector2D {
	return Vector2D(vector.x / float_2.x, vector.y / float_2.y)
}

// MARK:	float2 / Vector2D
public func / (float_2: float2, vector: Vector2D) -> Vector2D {
	return Vector2D(float_2.x / vector.x, float_2.y / vector.y)
}

// MARK:	Vector2D /= float2
public func /= (inout vector: Vector2D, float_2: float2) {
	vector = vector / float_2
}