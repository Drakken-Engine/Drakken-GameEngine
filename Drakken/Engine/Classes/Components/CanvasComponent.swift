//
// Created by Allison Lindner on 26/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import simd

@objc class CanvasComponent: NSObject, InternalComponent, Component {
	private var _renderer: Renderer!

	private(set) var _transform: Transform!
	var transform: Transformable!

	var descriptor: Descriptor!

	//----------------------------------------------------//

	//Projection Matrix
	var projectionMatrix: float4x4!
	//View Matrix
	var viewMatrix: float4x4!

	var sharedUniform: SharedUniforms!
	var sharedUniformBuffer: MTLBuffer!

	//----------------------------------------------------//

	private var _children: [InternalComponent]!

	private var _texture: MTLTexture!
	private var _maskTexture: MTLTexture

	private var _size: CGSize

	var index: Int = 0

	init(size: CGSize, position: CGPoint) {
		_transform = Transform()
		transform = _transform

		_size = size

		_renderer = Renderer()
		_children = [InternalComponent]()

		let screenScale = Core.screenScale

		projectionMatrix = newOrtho(
		-Float(size.width/2.0) 	* screenScale,
				right: 	 Float(size.width/2.0) 	* screenScale,
				bottom:	 Float(size.height/2.0) * screenScale,
				top: 	-Float(size.height/2.0) * screenScale,
				near: 	-1000,
				far: 	 1000
		)

		viewMatrix = newTranslation(float3(0.0, 0.0, -500.0))

		_maskTexture = Resource.loadTexture("white_pixel.png")

		super.init()

		_texture = Resource.emptyTexture(size)
		updateSharedUniformBuffer()
	}

	func getComponent() -> InternalComponent {
		return self
	}

	func setMaskTexture(texture: MTLTexture) {
		_maskTexture = texture
	}

	func updateSharedUniformBuffer() {

		sharedUniform = SharedUniforms(
		projectionMatrix:	projectionMatrix,
				viewMatrix:			viewMatrix
		)

		sharedUniformBuffer = Core.device.newBufferWithBytes(
		&sharedUniform,
				length: sizeof(SharedUniforms),
				options: .CPUCacheModeDefaultCache
		)
	}

	func addNode(node: Component) {
		_children.append(node as! InternalComponent)
	}

	func update(deltaTime: CFTimeInterval) {
		for child: InternalComponent in _children {
			child.update(deltaTime)
		}
	}

	func drawOnTargetTexture(texture: MTLTexture) {
		_renderer.startFrame(texture: texture)

		_renderer.renderCommandEncoder.setVertexBuffer(sharedUniformBuffer, offset: 0, atIndex: 0)

		for child: InternalComponent in _children {
			child.draw(_renderer)
		}
		_renderer.endFrame()
	}

	func draw(renderer: Renderer) {
		for child: InternalComponent in _children {
			child.draw(renderer)
		}
	}
}
