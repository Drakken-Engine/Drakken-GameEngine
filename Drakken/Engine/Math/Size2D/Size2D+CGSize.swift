//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK:	CGSize
// MARK:	Vector2D + CGSize
public func + (size: Vector2D, cg_size: CGSize) -> Vector2D {
	return Vector2D(size.x + Float(cg_size.width), size.y + Float(cg_size.height))
}

// MARK:	Vector2D += float2
public func += (inout size: Vector2D, cg_size: CGSize) {
	size = size + cg_size
}

// MARK:	Vector2D - CGSize
public func - (size: Vector2D, cg_size: CGSize) -> Vector2D {
	return Vector2D(size.x - Float(cg_size.width), size.y - Float(cg_size.height))
}

// MARK:	Vector2D -= CGSize
public func -= (inout size: Vector2D, cg_size: CGSize) {
	size = size - cg_size
}

// MARK:	Vector2D * CGSize
public func * (size: Vector2D, cg_size: CGSize) -> Vector2D {
	return Vector2D(size.x * Float(cg_size.width), size.y * Float(cg_size.height))
}

// MARK:	Vector2D *= CGSize
public func *= (inout size: Vector2D, cg_size: CGSize) {
	size = size * cg_size
}

// MARK:	Vector2D / CGSize
public func / (size: Vector2D, cg_size: CGSize) -> Vector2D {
	return Vector2D(size.x / Float(cg_size.width), size.y / Float(cg_size.height))
}

// MARK:	Vector2D /= CGSize
public func /= (inout size: Vector2D, cg_size: CGSize) {
	size = size / cg_size
}