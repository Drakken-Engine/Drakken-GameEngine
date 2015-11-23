//
//  BaseShader.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 27/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal

class BaseShader {
	private var _vertexCount: Int!
	private var _indexBuffer: IndexBuffer!
	private var _modelMatrixBuffer: MTLBuffer!

	var samplerState: MTLSamplerState!
	var drawMode: MTLPrimitiveType!
	
	init () {
		drawMode = .Triangle
		
		let samplerDescriptor = MTLSamplerDescriptor()
		samplerDescriptor.minFilter = .Nearest
		samplerDescriptor.magFilter = .Linear
		samplerDescriptor.sAddressMode = .Repeat
		samplerDescriptor.tAddressMode = .Repeat
		samplerDescriptor.rAddressMode = .ClampToEdge
		samplerDescriptor.normalizedCoordinates = true
		samplerDescriptor.lodMinClamp = 0
		samplerDescriptor.lodMaxClamp = FLT_MAX
		
		samplerState = Core.device.newSamplerStateWithDescriptor(samplerDescriptor)
	}
	
	func prepareToDraw(renderer: Renderer, shaderBuffers: ShaderBuffers) {
		for buffer: DataBuffer in shaderBuffers.vertexBuffer {
			if buffer.index < 8 {
				renderer.renderCommandEncoder.setVertexBuffer(buffer.buffer, offset: 0, atIndex: buffer.index)
			}
		}
		
		for texture: TextureBuffer in shaderBuffers.textureBuffer {
			renderer.renderCommandEncoder.setFragmentTexture(texture.texture, atIndex: texture.index)
		}

		for buffer: DataBuffer in shaderBuffers.fragmentBuffer {
			if buffer.index < 8 {
				renderer.renderCommandEncoder.setFragmentBuffer(buffer.buffer, offset: 0, atIndex: buffer.index)
			}
		}

		_indexBuffer = shaderBuffers.indexBuffer
		_vertexCount = shaderBuffers.vertexCount
		
		renderer.renderCommandEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
	}
	
	func draw(renderer: Renderer) {
		if _indexBuffer.indexCount > 0 {
			renderer.renderCommandEncoder.drawIndexedPrimitives(drawMode,
				indexCount: _indexBuffer.indexCount,
				indexType: .UInt32,
				indexBuffer: _indexBuffer.buffer,
				indexBufferOffset: 0
			)
		} else if _vertexCount > 0 {
			renderer.renderCommandEncoder.drawPrimitives(drawMode, vertexStart: 0, vertexCount: _vertexCount)
		}
	}
}