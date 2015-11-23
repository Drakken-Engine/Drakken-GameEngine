//
//  FluidComponent.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 23/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd

@objc class FluidComponent: NSObject, InternalComponent, Component {
	
	private var _fluids: [String: FluidMesh]!
	private var _fluidCanvas: EffectCanvasComponent!
	
	private var _world: World!

	private(set) var _transform: Transform!

	var transform: Transformable!

	var descriptor: Descriptor!

	var index: Int = 0
	
	init(world: World) {
		_fluids = [String: FluidMesh]()
		
		_world = world

		_transform = Transform()
		transform = _transform

		descriptor = Descriptor()
		
		_fluidCanvas = EffectCanvasComponent(size: Core.screenSize, position: CGPointZero)
		_fluidCanvas.setEffectMaterial("fluid")
		
		super.init()
		_fluidCanvas.addNode(self)
	}
	
	func getComponent() -> InternalComponent {
		return _fluidCanvas
	}

	func getCanvas() -> EffectCanvasComponent {
		return _fluidCanvas
	}
	
	func addNewFluid(radius: Float, dampingStrength: Float, gravityScale: Float, density: Float, label: String) {
		let fluid = FluidMesh(
			materialName: "fluid",
			radius: radius,
			dampingStrength: dampingStrength,
			gravityScale: gravityScale,
			density: density,
			world: _world,
			node: self
		)
		
		_fluids.updateValue(fluid, forKey: label)
	}
	
	func getFluid(label: String) -> Fluid {
		return _fluids[label]!.getFluid()
	}

	func update(deltaTime: CFTimeInterval) {
		_fluidCanvas.transform.setZPosition(_transform.getZPosition())
	}

	func draw(renderer: Renderer) {
		for fluid: (String, FluidMesh) in _fluids {
			fluid.1.prepareToDraw(renderer, transform: _transform)
			fluid.1.draw(renderer)
		}
	}
}