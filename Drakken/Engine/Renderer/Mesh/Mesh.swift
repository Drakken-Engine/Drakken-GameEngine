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

public class Mesh {
	internal var drawMode: MTLPrimitiveType
	internal var indices: [UInt32]
	internal var vertexCount: Int

	internal var modelMatrix: float4x4

	private var _modelUniform: ModelUniforms!

	internal var _shader: Shader

	public convenience init() {
		self.init(shaderName: "basic")
	}
	
	public init(shaderName: String) {
		drawMode = .Triangle
		indices = [UInt32]()
		vertexCount = 0
		modelMatrix = float4x4()

		_shader = Shader(vertex: shaderName + "_vertex", fragment: shaderName + "_fragment")
	}

	public func setMaterial(shaderName: String) {
		_shader = Shader(vertex: shaderName + "_vertex", fragment: shaderName + "_fragment")
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
			if (!renderer.lastRenderPipelineState.isEqual(_shader.renderPipelineState)) {
				renderer.renderCommandEncoder.setRenderPipelineState(_shader.renderPipelineState)
				renderer.lastRenderPipelineState = _shader.renderPipelineState
			}
		} else {
			renderer.renderCommandEncoder.setRenderPipelineState(_shader.renderPipelineState)
			renderer.lastRenderPipelineState = _shader.renderPipelineState
		}
		
		let modelUniformBuffer = Core.device.newBufferWithBytes(&_modelUniform, length: sizeof(ModelUniforms), options: .CPUCacheModeDefaultCache)
		renderer.renderCommandEncoder.setVertexBuffer(modelUniformBuffer, offset: 0, atIndex: 1)
		renderer.renderCommandEncoder.setFragmentBuffer(_shader.materialPropertiesUniformBuffer, offset: 0, atIndex: 1)

		if indices.count > 0 {
			_shader.indexBuffer = IndexBuffer(data: indices, indexCount: indices.count)
		} else if vertexCount > 0 {
			_shader.vertexCount = vertexCount
		}

		_shader.drawMode = drawMode
		_shader.prepareToDraw(renderer)
	}
	
	internal func draw(renderer: Renderer) {
		_shader.draw(renderer)
	}
}