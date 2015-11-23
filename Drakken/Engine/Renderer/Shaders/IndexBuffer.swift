//
//  IndexBuffer.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 30/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal

class IndexBuffer {
	var buffer: MTLBuffer
	var indexCount: Int
	
	init (buffer: MTLBuffer, indexCount: Int) {
		self.buffer = buffer
		self.indexCount = indexCount
	}

	init (data: [UInt32], indexCount: Int) {
		self.buffer = Core.device.newBufferWithBytes(
				data,
				length: sizeof(UInt32) * indexCount,
				options: MTLResourceOptions.CPUCacheModeDefaultCache
		)
		self.indexCount = indexCount
	}

	init (indexCount: Int) {
		self.buffer = Core.device.newBufferWithLength(
			0,
			options: MTLResourceOptions.CPUCacheModeDefaultCache
		)
		self.indexCount = indexCount
	}
}