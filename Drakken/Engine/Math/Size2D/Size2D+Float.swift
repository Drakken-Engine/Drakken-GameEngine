//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Float
// MARK:	Size2D + Float
public func + (size: Size2D, scalar: Float) -> Size2D {
	return Size2D(size.width + scalar, size.height + scalar)
}

// MARK:	Size2D += Float
public func += (inout size: Size2D, scalar: Float) {
	size = size + scalar
}

// MARK:	Size2D - Float
public func - (size: Size2D, scalar: Float) -> Size2D {
	return Size2D(size.width - scalar, size.height - scalar)
}

// MARK:	Size2D -= Float
public func -= (inout size: Size2D, scalar: Float) {
	size = size - scalar
}

// MARK:	Size2D * Float
public func * (size: Size2D, scalar: Float) -> Size2D {
	return Size2D(size.width * scalar, size.height * scalar)
}

// MARK:	Size2D *= Float
public func *= (inout size: Size2D, scalar: Float) {
	size = size * scalar
}

// MARK:	Size2D / Float
public func / (size: Size2D, scalar: Float) -> Size2D {
	return Size2D(size.width / scalar, size.height / scalar)
}

// MARK:	Size2D /= Float
public func /= (inout size: Size2D, scalar: Float) {
	size = size / scalar
}