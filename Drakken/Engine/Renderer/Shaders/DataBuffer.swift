//
//  DataBuffer.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 29/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import simd

class DataBuffer {
	var buffer: MTLBuffer
	var index: Int
	
	init(buffer: MTLBuffer, index: Int) {
		self.buffer = buffer
		self.index = index
	}
	
	init(index: Int) {
		self.buffer = Core.device.newBufferWithLength(0, options: MTLResourceOptions.CPUCacheModeDefaultCache)
		self.index = index
	}

	convenience init(float2Data data: UnsafeMutablePointer<float2>, length: Int, index: Int) {
		let buffer = Core.device.newBufferWithBytes(data, length: length, options: MTLResourceOptions.CPUCacheModeDefaultCache)

		self.init(buffer: buffer, index: index)
	}

	convenience init(float3Data data: UnsafeMutablePointer<float3>, length: Int, index: Int) {
		let buffer = Core.device.newBufferWithBytes(data, length: length, options: MTLResourceOptions.CPUCacheModeDefaultCache)

		self.init(buffer: buffer, index: index)
	}

	convenience init(float4Data data: UnsafeMutablePointer<float4>, length: Int, index: Int) {
		let buffer = Core.device.newBufferWithBytes(data, length: length, options: MTLResourceOptions.CPUCacheModeDefaultCache)

		self.init(buffer: buffer, index: index)
	}

	convenience init(floatData data: UnsafeMutablePointer<Float>, length: Int, index: Int) {
		let buffer = Core.device.newBufferWithBytes(data, length: length, options: MTLResourceOptions.CPUCacheModeDefaultCache)

		self.init(buffer: buffer, index: index)
	}

	convenience init(boolData data: UnsafeMutablePointer<Bool>, length: Int, index: Int) {
		let buffer = Core.device.newBufferWithBytes(data, length: length, options: MTLResourceOptions.CPUCacheModeDefaultCache)

		self.init(buffer: buffer, index: index)
	}

	convenience init(voidData data: UnsafeMutablePointer<Void>, length: Int, index: Int) {
		let buffer = Core.device.newBufferWithBytes(data, length: length, options: MTLResourceOptions.CPUCacheModeDefaultCache)

		self.init(buffer: buffer, index: index)
	}
}