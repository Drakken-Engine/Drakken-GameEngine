//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Double
// MARK:	Size2D + Double
public func + (size: Size2D, scalar: Double) -> Size2D {
	return Size2D(size.width + Float(scalar), size.height + Float(scalar))
}

// MARK:	Size2D += Double
public func += (inout size: Size2D, scalar: Double) {
	size = size + scalar
}

// MARK:	Size2D - Double
public func - (size: Size2D, scalar: Double) -> Size2D {
	return Size2D(size.width - Float(scalar), size.height - Float(scalar))
}

// MARK:	Size2D -= Double
public func -= (inout size: Size2D, scalar: Double) {
	size = size - scalar
}

// MARK:	Size2D * Double
public func * (size: Size2D, scalar: Double) -> Size2D {
	return Size2D(size.width * Float(scalar), size.height * Float(scalar))
}

// MARK:	Size2D *= Double
public func *= (inout size: Size2D, scalar: Double) {
	size = size * scalar
}

// MARK:	Size2D / Double
public func / (size: Size2D, scalar: Double) -> Size2D {
	return Size2D(size.width / Float(scalar), size.height / Float(scalar))
}

// MARK:	Size2D /= Double
public func /= (inout size: Size2D, scalar: Double) {
	size = size / scalar
}