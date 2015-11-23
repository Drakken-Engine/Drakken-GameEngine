//
// Created by Allison Lindner on 10/11/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd

// MARK:	float2
// MARK:	Size2D + float2
public func + (size: Size2D, float_2: float2) -> Size2D {
	return Size2D(size.width + float_2.x, size.height + float_2.y)
}

// MARK:	Size2D += float2
public func += (inout size: Size2D, float_2: float2) {
	size = size + float_2
}

// MARK:	Size2D - float2
public func - (size: Size2D, float_2: float2) -> Size2D {
	return Size2D(size.width - float_2.x, size.height - float_2.y)
}

// MARK:	Size2D -= float2
public func -= (inout size: Size2D, float_2: float2) {
	size = size - float_2
}

// MARK:	Size2D * float2
public func * (size: Size2D, float_2: float2) -> Size2D {
	return Size2D(size.width * float_2.x, size.height * float_2.y)
}

// MARK:	Size2D *= float2
public func *= (inout size: Size2D, float_2: float2) {
	size = size * float_2
}

// MARK:	Size2D / float2
public func / (size: Size2D, float_2: float2) -> Size2D {
	return Size2D(size.width / float_2.x, size.height / float_2.y)
}

// MARK:	Size2D /= float2
public func /= (inout size: Size2D, float_2: float2) {
	size = size / float_2
}