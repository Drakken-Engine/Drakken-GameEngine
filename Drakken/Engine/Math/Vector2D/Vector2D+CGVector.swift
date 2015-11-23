//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK:	CGVector
// MARK:	Vector2D + CGVector
public func + (vector: Vector2D, cg_vector: CGVector) -> Vector2D {
	return Vector2D(vector.x + Float(cg_vector.dx), vector.y + Float(cg_vector.dy))
}

// MARK:	CGVector + Vector2D
public func + (cg_vector: CGVector, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_vector.dx) + vector.x, Float(cg_vector.dy) + vector.y)
}

// MARK:	Vector2D += float2
public func += (inout vector: Vector2D, cg_vector: CGVector) {
	vector = vector + cg_vector
}

// MARK:	Vector2D - CGVector
public func - (vector: Vector2D, cg_vector: CGVector) -> Vector2D {
	return Vector2D(vector.x - Float(cg_vector.dx), vector.y - Float(cg_vector.dy))
}

// MARK:	CGVector - Vector2D
public func - (cg_vector: CGVector, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_vector.dx) - vector.x, Float(cg_vector.dy) - vector.y)
}

// MARK:	Vector2D -= CGVector
public func -= (inout vector: Vector2D, cg_vector: CGVector) {
	vector = vector - cg_vector
}

// MARK:	Vector2D * CGVector
public func * (vector: Vector2D, cg_vector: CGVector) -> Vector2D {
	return Vector2D(vector.x * Float(cg_vector.dx), vector.y * Float(cg_vector.dy))
}

// MARK:	CGVector * Vector2D
public func * (cg_vector: CGVector, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_vector.dx) * vector.x, Float(cg_vector.dy) * vector.y)
}

// MARK:	Vector2D *= CGVector
public func *= (inout vector: Vector2D, cg_vector: CGVector) {
	vector = vector * cg_vector
}

// MARK:	Vector2D / CGVector
public func / (vector: Vector2D, cg_vector: CGVector) -> Vector2D {
	return Vector2D(vector.x / Float(cg_vector.dx), vector.y / Float(cg_vector.dy))
}

// MARK:	CGVector / Vector2D
public func / (cg_vector: CGVector, vector: Vector2D) -> Vector2D {
	return Vector2D(Float(cg_vector.dx) / vector.x, Float(cg_vector.dy) / vector.y)
}

// MARK:	Vector2D /= CGVector
public func /= (inout vector: Vector2D, cg_vector: CGVector) {
	vector = vector / cg_vector
}