//
//  Mesh.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import Metal
import MetalKit
import simd

public class Mesh: ShaderVertexData, ShaderFragmentTextureData, ShaderFragmentBufferData {
	private var _positions: [float3]
	internal var positions: [float3] {
		get {
			return self._positions
		}
		set {
			self._positions = newValue
			_shaderBuffers.vertexBuffer[0] = DataBuffer(float3Data: &_positions, length: sizeof(float3) * newValue.count, index: 2)
		}
	}
	private var _normals: [float3]
	internal var normals: [float3] {
		get {
			return self._normals
		}
		set {
			self._normals = newValue
			_shaderBuffers.vertexBuffer[1] = DataBuffer(float3Data: &_normals, length: sizeof(float3) * newValue.count, index: 3)
		}
	}
	private var _texcoords: [float2]
	internal var texcoords: [float2] {
		get {
			return self._texcoords
		}
		set {
			self._texcoords = newValue
			_shaderBuffers.vertexBuffer[2] = DataBuffer(float2Data: &_texcoords, length: sizeof(float2) * newValue.count, index: 4)
		}
	}
	private var _colors: [float4]
	internal var colors: [float4] {
		get {
			return self._colors
		}
		set {
			self._colors = newValue
			_shaderBuffers.vertexBuffer[3] = DataBuffer(float4Data: &_colors, length: sizeof(float4) * newValue.count, index: 5)
		}
	}
	private var _pointSize: Float
	internal var pointSize: Float {
		get {
			return self._pointSize
		}
		set {
			if self._pointSize != newValue {
				self._pointSize = newValue
				_shaderBuffers.vertexBuffer[4] = DataBuffer(floatData: &_pointSize, length: sizeof(Float), index: 6)
			}
		}
	}
	private var _particlesPositions: MTLBuffer
	internal var particlesPositions: MTLBuffer {
		get {
			return self._particlesPositions
		}
		set {
			self._particlesPositions = newValue
			_shaderBuffers.vertexBuffer[5] = DataBuffer( buffer: newValue, index: 7)
		}
	}

	private var _textureRepeat: float2
	internal var textureRepeat: float2 {
		get {
			return self._textureRepeat
		}
		set {
			self._textureRepeat = newValue
			_shaderBuffers.fragmentBuffer[0] = DataBuffer(float2Data: &_textureRepeat, length: sizeof(float2), index: 2)
		}
	}
	private var _repeatMask: Bool
	internal var repeatMask: Bool {
		get {
			return self._repeatMask
		}
		set {
			self._repeatMask = newValue
			_shaderBuffers.fragmentBuffer[1] = DataBuffer(boolData: &_repeatMask, length: sizeof(Bool), index: 3)
		}
	}
	private var _texcoordsOffset: float2
	internal var texcoordsOffset: float2 {
		get {
			return self._texcoordsOffset
		}
		set {
			self._texcoordsOffset = newValue
			_shaderBuffers.fragmentBuffer[2] = DataBuffer(float2Data: &_texcoordsOffset, length: sizeof(float2), index: 4)
		}
	}
	
	private var _texture1: Texture
	internal var texture1: Texture {
		get {
			return self._texture1
		}
		set {
			self._texture1 = newValue
			_shaderBuffers.textureBuffer[3] = TextureBuffer(texture: newValue, index: 3)
		}
	}
	private var _texture2: Texture
	internal var texture2: Texture {
		get {
			return self._texture2
		}
		set {
			self._texture2 = newValue
			_shaderBuffers.textureBuffer[4] = TextureBuffer(texture: newValue, index: 4)
		}
	}
	private var _maskTexture: Texture
	internal var maskTexture: Texture {
		get {
			return self._maskTexture
		}
		set {
			self._maskTexture = newValue
			_shaderBuffers.textureBuffer[5] = TextureBuffer(texture: newValue, index: 5)
		}
	}

	internal var drawMode: MTLPrimitiveType
	internal var indices: [UInt32]
	internal var vertexCount: Int

	internal var modelMatrix: float4x4

	private var _shaderBuffers: ShaderBuffers
	private var _modelUniform: ModelUniforms!
	private var _material: Material
	private var _shader: BaseShader

	public convenience init() {
		self.init(materialName: "basic")
	}
	
	public init(materialName: String) {
		drawMode = .Triangle
		indices = [UInt32]()
		vertexCount = 0
		modelMatrix = float4x4()

		_shaderBuffers = ShaderBuffers()
		_shader = BaseShader()

		_material = Core.materialManager.getMaterial(materialName)

		_positions 	= [float3]();
		_normals 	= [float3]();
		_texcoords 	= [float2]();
		_colors 	= [float4]();
		_pointSize 	= 0.0;

		_particlesPositions = Core.device.newBufferWithLength(0, options: MTLResourceOptions.CPUCacheModeDefaultCache);

		_textureRepeat = float2(0.0)
		_texcoordsOffset = float2(0.0)
		_repeatMask = false

		_texture1 = Texture(fileName: "black_pixel.png")
		_texture2 = Texture(fileName: "black_pixel.png")
		_maskTexture = Texture(fileName: "white_pixel.png")
	}

	public func setMaterial(name: String) {
		_material = Core.materialManager.getMaterial(name)
	}
	
	internal func updateModelUniform(transform: Transform) {
		modelMatrix = transform.getModelMatrix() *
						newScale(
							   transform.getMeshScale().x,
							y: transform.getMeshScale().y,
							z: 1.0
						)
		_modelUniform = ModelUniforms(parentModelMatrix: modelMatrix, modelMatrix: modelMatrix)
	}
	
	internal func prepareToDraw(renderer: Renderer, transform: Transform) {
		self.updateModelUniform(transform)

		if (renderer.lastRenderPipelineState != nil) {
			if (!renderer.lastRenderPipelineState.isEqual(_material.renderPipelineState)) {
				renderer.renderCommandEncoder.setRenderPipelineState(_material.renderPipelineState)
				renderer.lastRenderPipelineState = _material.renderPipelineState
			}
		} else {
			renderer.renderCommandEncoder.setRenderPipelineState(_material.renderPipelineState)
			renderer.lastRenderPipelineState = _material.renderPipelineState
		}
		
		let modelUniformBuffer = Core.device.newBufferWithBytes(&_modelUniform, length: sizeof(ModelUniforms), options: .CPUCacheModeDefaultCache)
		renderer.renderCommandEncoder.setVertexBuffer(modelUniformBuffer, offset: 0, atIndex: 1)
		renderer.renderCommandEncoder.setFragmentBuffer(_material.materialPropertiesUniformBuffer, offset: 0, atIndex: 1)

		if indices.count > 0 {
			_shaderBuffers.indexBuffer = IndexBuffer(data: indices, indexCount: indices.count)
		} else if vertexCount > 0 {
			_shaderBuffers.vertexCount = vertexCount
		}

		_shader.drawMode = drawMode
		_shader.prepareToDraw(renderer, shaderBuffers: _shaderBuffers)
	}
	
	internal func draw(renderer: Renderer) {
		_shader.draw(renderer)
	}
}