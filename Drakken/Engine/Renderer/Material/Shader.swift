//
//  Shader.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 05/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import Metal
import MetalKit
import simd

public class Shader: NSObject {
	private var _vertexCount: Int!
	private var _indexBuffer: IndexBuffer!
	private var _modelMatrixBuffer: MTLBuffer!

	var samplerState: MTLSamplerState!
	var drawMode: MTLPrimitiveType!

	internal var vertexBuffer: [Int: DataBuffer]
	internal var textureBuffer: [Int: TextureBuffer]
	internal var fragmentBuffer: [Int: DataBuffer]

	internal var indexBuffer: IndexBuffer
	internal var vertexCount: Int

	private var fragmentShaderFunction: MTLFunction!
	private var vertexShaderFunction: MTLFunction!

	internal var renderPipelineState: MTLRenderPipelineState!
	
	internal var materialPropertiesUniform: MaterialProperties!
	internal var materialPropertiesUniformBuffer: MTLBuffer!

	private var _shaderReflextion: MTLRenderPipelineReflection?
	
	init (vertex: String, fragment: String) {
		vertexBuffer = [Int: DataBuffer]()
		textureBuffer = [Int: TextureBuffer]()
		fragmentBuffer = [Int: DataBuffer]()

		indexBuffer	= IndexBuffer(indexCount: 0)
		vertexCount = 0

		super.init()

		fragmentShaderFunction	= Core.library.newFunctionWithName(fragment);
		vertexShaderFunction	= Core.library.newFunctionWithName(vertex);
		
		let renderPipelineStateDescriptor = buildRenderPipelineDescriptor()

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
		
		do {
			renderPipelineState = try Core.device.newRenderPipelineStateWithDescriptor(renderPipelineStateDescriptor)
		} catch {
			renderPipelineState = nil
			print("Error occurred when creating render pipeline state: \(error)")
		}
	}
	
	func buildRenderPipelineDescriptor() -> MTLRenderPipelineDescriptor {
		let rpDescriptor = MTLRenderPipelineDescriptor()
		
		rpDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		rpDescriptor.colorAttachments[0].blendingEnabled = true
		
		rpDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.Add
		rpDescriptor.colorAttachments[0].rgbBlendOperation = MTLBlendOperation.Add
		
		rpDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.SourceAlpha
		rpDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		
		rpDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.SourceAlpha
		rpDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		
		rpDescriptor.depthAttachmentPixelFormat = .Depth32Float_Stencil8
		rpDescriptor.stencilAttachmentPixelFormat = .Depth32Float_Stencil8
		
		rpDescriptor.fragmentFunction = fragmentShaderFunction
		rpDescriptor.vertexFunction = vertexShaderFunction
		
		return rpDescriptor
	}

	public func setVertexData(buffer data: MTLBuffer, index: Int) {
		vertexBuffer.updateValue(DataBuffer(buffer: data, index: index), forKey: index)
	}

	public func setVertexData(float data: UnsafeMutablePointer<Float>, length: Int, index: Int) {
		vertexBuffer.updateValue(DataBuffer(floatData: data, length: length, index: index), forKey: index)
	}

	public func setVertexData(float2 data: UnsafeMutablePointer<float2>, length: Int, index: Int) {
		vertexBuffer.updateValue(DataBuffer(float2Data: data, length: length, index: index), forKey: index)
	}

	public func setVertexData(float3 data: UnsafeMutablePointer<float3>, length: Int, index: Int) {
		vertexBuffer.updateValue(DataBuffer(float3Data: data, length: length, index: index), forKey: index)
	}

	public func setVertexData(float4 data: UnsafeMutablePointer<float4>, length: Int, index: Int) {
		vertexBuffer.updateValue(DataBuffer(float4Data: data, length: length, index: index), forKey: index)
	}

	public func setVertexData(bool data: UnsafeMutablePointer<Bool>, length: Int, index: Int) {
		vertexBuffer.updateValue(DataBuffer(boolData: data, length: length, index: index), forKey: index)
	}

	public func setVertexData(void data: UnsafeMutablePointer<Void>, length: Int, index: Int) {
		vertexBuffer.updateValue(DataBuffer(voidData: data, length: length, index: index), forKey: index)
	}

	public func setFragmentData(float data: UnsafeMutablePointer<Float>, length: Int, index: Int) {
		fragmentBuffer.updateValue(DataBuffer(floatData: data, length: length, index: index), forKey: index)
	}

	public func setFragmentData(float2 data: UnsafeMutablePointer<float2>, length: Int, index: Int) {
		fragmentBuffer.updateValue(DataBuffer(float2Data: data, length: length, index: index), forKey: index)
	}

	public func setFragmentData(float3 data: UnsafeMutablePointer<float3>, length: Int, index: Int) {
		fragmentBuffer.updateValue(DataBuffer(float3Data: data, length: length, index: index), forKey: index)
	}

	public func setFragmentData(float4 data: UnsafeMutablePointer<float4>, length: Int, index: Int) {
		fragmentBuffer.updateValue(DataBuffer(float4Data: data, length: length, index: index), forKey: index)
	}

	public func setFragmentData(bool data: UnsafeMutablePointer<Bool>, length: Int, index: Int) {
		fragmentBuffer.updateValue(DataBuffer(boolData: data, length: length, index: index), forKey: index)
	}

	public func setFragmentData(void data: UnsafeMutablePointer<Void>, length: Int, index: Int) {
		fragmentBuffer.updateValue(DataBuffer(voidData: data, length: length, index: index), forKey: index)
	}

	public func setTexture(texture: Texture, index: Int) {
		textureBuffer.updateValue(TextureBuffer(texture: texture, index: index), forKey: index)
	}

	func prepareToDraw(renderer: Renderer) {
		for buffer: (Int, DataBuffer) in vertexBuffer {
			renderer.renderCommandEncoder.setVertexBuffer(buffer.1.buffer, offset: 0, atIndex: buffer.1.index)
		}

		for texture: (Int, TextureBuffer) in textureBuffer {
			renderer.renderCommandEncoder.setFragmentTexture(texture.1.texture, atIndex: texture.1.index)
		}

		for buffer: (Int, DataBuffer) in fragmentBuffer {
			renderer.renderCommandEncoder.setFragmentBuffer(buffer.1.buffer, offset: 0, atIndex: buffer.1.index)
		}

		_indexBuffer = indexBuffer
		_vertexCount = vertexCount

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