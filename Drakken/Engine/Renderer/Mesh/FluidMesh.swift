//
//  FluidMesh.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 29/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import simd

class FluidMesh: Mesh {
	
	private var _fluid: Fluid
	private var _component: Component

	private var pointSize: Float
	private var particlesPosition: UnsafeMutablePointer<Void>!
	
	init(	materialName: 		String,
			radius: 			Float,
			dampingStrength:	Float,
			gravityScale: 		Float,
			density: 			Float,
			world: 				World!,
			node: 				Component)
	{
		_fluid = Fluid(
			radius: 			radius,
			dampingStrength: 	dampingStrength,
			gravityScale: 		gravityScale,
			density: 			density,
			world: 				world,
			component: 			node
		)
		_component = node

		pointSize = radius * 1.8
		particlesPosition = _fluid.getPositionBuffer()
		
		super.init(shaderName: "texture_particle")

		modelMatrix = newScale(1)

		_shader.setVertexData(float: &pointSize, length: sizeof(Float), index: 3)
		_shader.setTexture(Texture(fileName: "circle"), index: 0)
	}
	
	func getFluid() -> Fluid {
		return _fluid
	}
	
	func updatePositionBuffer() {
		particlesPosition = _fluid.getPositionBuffer()
		
		if _fluid.getParticleCount() > 0 {
			let particlesBuffer = Core.device.newBufferWithBytes(
												particlesPosition,
												length: sizeof(Float) * 2 * Int(_fluid.getParticleCount()),
												options: MTLResourceOptions.CPUCacheModeDefaultCache
											)
			
			_shader.setVertexData(buffer: particlesBuffer, index: 2)
		} else {
			let particlesBuffer = Core.device.newBufferWithBytes(
				UnsafeMutablePointer(bitPattern: 0), length: 0, options: MTLResourceOptions.CPUCacheModeDefaultCache
			)
			
			_shader.setVertexData(buffer: particlesBuffer, index: 2)
		}
	}
	
	override func prepareToDraw(renderer: Renderer, transform: Transform) {
		updatePositionBuffer()
		
		let particlesCount = Int(_fluid.getParticleCount())
		
		drawMode = .Point
		vertexCount = particlesCount
		super.prepareToDraw(renderer, transform: transform)
	}
	
	override func draw(renderer: Renderer) {
		super.draw(renderer)
	}
}