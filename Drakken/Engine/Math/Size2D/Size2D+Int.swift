//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Int
// MARK:	Size2D + Int
public func + (size: Size2D, scalar: Int) -> Size2D {
	return Size2D(size.width + Float(scalar), size.height + Float(scalar))
}

// MARK:	Size2D += Int
public func += (inout size: Size2D, scalar: Int) {
	size = size + scalar
}

// MARK:	Size2D - Int
public func - (size: Size2D, scalar: Int) -> Size2D {
	return Size2D(size.width - Float(scalar), size.height - Float(scalar))
}

// MARK:	Size2D -= Int
public func -= (inout size: Size2D, scalar: Int) {
	size = size - scalar
}

// MARK:	Size2D * Int
public func * (size: Size2D, scalar: Int) -> Size2D {
	return Size2D(size.width * Float(scalar), size.height * Float(scalar))
}

// MARK:	Size2D *= Int
public func *= (inout size: Size2D, scalar: Int) {
	size = size * scalar
}

// MARK:	Size2D / Int
public func / (size: Size2D, scalar: Int) -> Size2D {
	return Size2D(size.width / Float(scalar), size.height / Float(scalar))
}

// MARK:	Size2D /= Int
public func /= (inout size: Size2D, scalar: Int) {
	size = size / scalar
}