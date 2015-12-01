//
//  GEScene.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 04/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import simd
import Metal
import MetalKit

public class Scene: NSObject {
//	private var _metalLayer: CAMetalLayer!
	private var _renderer: Renderer!

	private var _components: [Int: InternalComponent]!

	private var _projectionMatrix: float4x4!
	private var _viewMatrix: float4x4!
	
	private var _sharedUniform: SharedUniforms!
	private var _sharedUniformBuffer: MTLBuffer!
	
//	private var _displayLink: CADisplayLink!
	
	private var _instantiateComponentQueue: [Component]!
	private var _deleteComponentQueue: [InternalComponent]!
	private var _transform: Transform!

	private var _indexCount: Int = 0
	
	private var _destroied: Bool = false
	
	private var _beforeUpdateHandler: () -> Void
	private var _afterUpdateHandler: () -> Void
	
	//##############################################//
	//##########         PHYSICS         ###########//
	//##############################################//

	public var world: World
	private var count = 0
	
	//##############################################//
	//##############################################//

	private var _worldSize: Size2D
	private var _worldQuads: [Int: [Int: [Component]]]!
	
	public var deltaTime: CFTimeInterval = 0.016
	private var _frameStartTime: CFTimeInterval = 0.0

	var modelMatrix: float4x4 {
		return _transform.getModelMatrix()
	}

	public var cameraScale: float2 {
		return _transform.getScale()
	}

	public var cameraTranslation: float2 {
		return _transform.getPosition()
	}

	init(_ beforeUpdateHandler: () -> Void, _ afterUpdateHandler: () -> Void) {
		world = World(gravity: CGVectorMake(0.0, -9.8))
		
		_renderer = Renderer()
		_components = [Int: InternalComponent]()
		_instantiateComponentQueue = [Component]()
		_deleteComponentQueue = [InternalComponent]()
		_transform = Transform()
		_worldSize = Size2D(1000000, 1000000)

		let screenSize = Core.screenSize
		let screenScale = Core.screenScale

		_transform.setZPosition(-1.0)
		
		_projectionMatrix = newOrtho(
					-Float(screenSize.width/2.0)  * screenScale,
			right:   Float(screenSize.width/2.0)  * screenScale,
			bottom:	-Float(screenSize.height/2.0) * screenScale,
			top: 	 Float(screenSize.height/2.0) * screenScale,
			near: 	-1000,
			far: 	 1000
		)
		
		_viewMatrix = _transform.getModelMatrix()
		
		_beforeUpdateHandler = beforeUpdateHandler
		_afterUpdateHandler = afterUpdateHandler
		
		super.init()
		
		updateSharedUniformBuffer()
	}

	func setupGameLoop(metalLayer: CAMetalLayer) {
//		_displayLink = CADisplayLink(target: self, selector: Selector("draw"))
//		_displayLink.frameInterval = 1
//		_displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

//		_metalLayer = metalLayer
	}

	func defineWorldSize(width: Float, _ heigth: Float) {
		_worldSize.width = width
		_worldSize.height = heigth
	}

	private func divideSpaceQuads() {
		_worldQuads = [Int: [Int: [Component]]]()

		if _components.count > 0 {

		}
	}

	func setCameraPosition(x: Float, _ y: Float, _ z: Float) {
		_transform.setPosition(float2(x, y))
		_transform.setZPosition(z)

		updateViewMatrix()
	}

	public func setCameraPosition(x: Float, _ y: Float) {
		setCameraPosition(x, y, _transform.getZPosition())
	}

	public func setCameraZPosition(z: Float) {
		setCameraPosition(_transform.getPosition().x, _transform.getPosition().y, z)
	}

	public func setCameraScale(x: Float, _ y: Float, _ z: Float) {
		_transform.setScale(float2(x, y))

		updateViewMatrix()
	}

	public func setCameraZRotationRadians(radians: Float) {
		_transform.setZRotationRadian(radians)

		updateViewMatrix()
	}

	public func setCameraZRotationDegree(degree: Float) {
		setCameraZRotationRadians(toRadians(degree))
	}
	
	public func addComponent(component: Component) {
		let mutableComponent: InternalComponent = (component as! InternalComponent).getComponent()
		if mutableComponent is Scriptable {
			(mutableComponent as! Scriptable).scene = self
		}
		let index = _indexCount++
		mutableComponent.index = index
		self._components.updateValue(mutableComponent, forKey: index)
	}

	public func removeComponent(component: Component) {
		self._deleteComponentQueue.append(component as! InternalComponent)
	}
	
	internal func addComponentToInstantiate(component: Component) {
		self._instantiateComponentQueue.append(component)
	}
	
	internal func updateSharedUniformBuffer() {
		_sharedUniform = SharedUniforms(
									projectionMatrix: _projectionMatrix,
									viewMatrix: _viewMatrix
								)
		
		_sharedUniformBuffer = Core.device.newBufferWithBytes(
													&_sharedUniform,
													length: sizeof(SharedUniforms),
													options: .CPUCacheModeDefaultCache
												)
	}

	internal func updateViewMatrix() {
		_viewMatrix = _transform.getModelMatrix()
		updateSharedUniformBuffer()
	}
	
	internal func update() {
		if !_destroied {
			for nodeToInstantiate: Component in _instantiateComponentQueue {
				addComponent(nodeToInstantiate)
				if nodeToInstantiate is Physical {
					(nodeToInstantiate as! Physical).createInWorld(world)
				}
			}
			_instantiateComponentQueue.removeAll(keepCapacity: true)

			for nodeToDelete: InternalComponent in _deleteComponentQueue {
				if nodeToDelete is GameComponent {
					(nodeToDelete as! GameComponent).deleteRigidbody(world)
				}
				_components.removeValueForKey(nodeToDelete.index)
			}
			_deleteComponentQueue.removeAll(keepCapacity: true)

			world.step()

			for node: (Int, InternalComponent) in _components {
				node.1.update(Double(deltaTime))
			}
		}
	}
	
	internal func draw(mtkView: MTKView) {
		_frameStartTime = CACurrentMediaTime()
		_beforeUpdateHandler()
		update()
		_afterUpdateHandler()
		
		guard let drawable = mtkView.currentDrawable else {
			print("Error!! mtkView.currentDrawable fail")
			exit(1)
		}
		
		_renderer.startFrame(drawable: drawable)
		_renderer.renderCommandEncoder.setVertexBuffer(_sharedUniformBuffer, offset: 0, atIndex: 0)
		
		for node: (Int, InternalComponent) in _components {
			node.1.draw(_renderer)
		}
		
		_renderer.endFrame(drawable: drawable)
		deltaTime = CACurrentMediaTime() - _frameStartTime
	}
	
	public func destroy() {
		_destroied = true
		world.destroy()
	}
}