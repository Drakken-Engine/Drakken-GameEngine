//
// Created by Allison Lindner on 09/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd
import Metal

@objc class EffectCanvasComponent: NSObject, InternalComponent, Component {

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

	private var _canvas: CanvasComponent!
	private var _target: GameComponent!

	private var _texture: Texture!
	private var _maskTexture: Texture

	private var _size: CGSize

	var index: Int = 0

	init(size: CGSize, position: CGPoint) {
		_transform = Transform()
		transform = _transform

		_size = size

		_renderer = Renderer()
		_canvas = CanvasComponent(size: size, position: position)

		let screenScale = Core.screenScale

		_target = GameComponent()
		_target.setMesh(
			Grid(width: 2, height: 2, textureRepeatXCount: 1, textureRepeatYCount: 1)
		)
		_target.transform.setMeshScale(float2(	Float(size.width)  * screenScale,
												Float(size.height) * screenScale))

		_maskTexture = Texture(fileName: "white_pixel.png")

		super.init()

		_texture = Texture(metalTexture: Resource.emptyTexture(size))
		updateSharedUniformBuffer()
	}
	
	func getComponent() -> InternalComponent {
		return self
	}

	func setEffectMaterial(name: String) {
		_target.setMaterial(name)
	}

	func setMaskTexture(texture: MTLTexture) {
		_canvas.setMaskTexture(texture)
	}

	func updateSharedUniformBuffer() {
		_canvas.updateSharedUniformBuffer()
	}

	func addNode(node: Component) {
		_canvas.addNode(node)
	}
	
	internal func updateWorldQuad(var worldQuad: [Int: [Int: [Component]]]) {
	}

	func update(deltaTime: CFTimeInterval) {
		_canvas.update(deltaTime)
	}

	func drawOnTargetTexture(texture: MTLTexture) {
		_texture = Texture(metalTexture: Resource.emptyTexture(_size))
		_canvas.drawOnTargetTexture(_texture.texture)

		_renderer.startFrame(texture: texture)
		_renderer.renderCommandEncoder.setVertexBuffer(sharedUniformBuffer, offset: 0, atIndex: 0)

		_target.setTexture(texture1: _texture)
		_target.setMaskTexture(_maskTexture)
		_target.setParentModelMatrix(_transform.getModelMatrix())
		_target.draw(_renderer)

		_renderer.endFrame()
	}

	func draw(renderer: Renderer) {
		_texture = Texture(metalTexture: Resource.emptyTexture(_size))
		_canvas.drawOnTargetTexture(_texture.texture)

		_target.setTexture(texture1: _texture)
		_target.setMaskTexture(_maskTexture)
		_target.setParentModelMatrix(_transform.getModelMatrix())

		_target.draw(renderer)
	}
}