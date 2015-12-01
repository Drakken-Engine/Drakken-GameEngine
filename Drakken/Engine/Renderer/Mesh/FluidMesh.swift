//
//  FluidMesh.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 29/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd

class FluidMesh: Mesh {
	
	private var _fluid: Fluid
	private var _component: Component
	
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

		super.init(materialName: "texture_particle")
		
		self.texture1 = Texture(fileName: "circle")
		pointSize = radius * 1.8
		modelMatrix = newScale(1)
	}
	
	func getFluid() -> Fluid {
		return _fluid
	}
	
	func updatePositionBuffer() {
		if _fluid.getParticleCount() > 0 {
			let _particleBuffer = Core.device.newBufferWithBytes(
												_fluid.getPositionBuffer(),
												length: sizeof(Float) * 2 * Int(_fluid.getParticleCount()),
												options: MTLResourceOptions.CPUCacheModeDefaultCache
											)
			
			particlesPositions = _particleBuffer
		} else {
			let _particleBuffer = Core.device.newBufferWithBytes(
				UnsafeMutablePointer(bitPattern: 0), length: 0, options: MTLResourceOptions.CPUCacheModeDefaultCache
			)
			
			particlesPositions = _particleBuffer
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