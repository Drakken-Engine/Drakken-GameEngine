//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation

// MARK:	Size2D
// MARK:	Size2D + Size2D
public func + (left: Size2D, right: Size2D) -> Size2D {
	return Size2D(left.width + right.width, left.height + right.height)
}

// MARK:	Size2D += Size2D
public func += (inout left: Size2D, right: Size2D) {
	left = left + right
}

// MARK:	Size2D - Size2D
public func - (left: Size2D, right: Size2D) -> Size2D {
	return Size2D(left.width - right.width, left.height - right.height)
}

// MARK:	Size2D -= Size2D
public func -= (inout left: Size2D, right: Size2D) {
	left = left - right
}

// MARK:	-Size2D
public prefix func - (size: Size2D) -> Size2D {
	return Size2D(-size.width, -size.height)
}

// MARK:	Size2D * Size2D
public func * (left: Size2D, right: Size2D) -> Size2D {
	return Size2D(left.width * right.width, left.height * right.height)
}

// MARK:	Size2D *= Size2D
public func *= (inout left: Size2D, right: Size2D) {
	left = left * right
}

// MARK:	Size2D / Size2D
public func / (left: Size2D, right: Size2D) -> Size2D {
	return Size2D(left.width / right.width, left.height / right.height)
}

// MARK:	Size2D /= Size2D
public func /= (inout left: Size2D, right: Size2D) {
	left = left / right
}