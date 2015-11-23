//
//  GEScene.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 04/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import simd

public class Scene: NSObject {
	private var _metalLayer: CAMetalLayer!
	private var _renderer: Renderer!

	private var _nodes: [Int: InternalComponent]!

	private var _projectionMatrix: float4x4!
	private var _viewMatrix: float4x4!
	
	private var _sharedUniform: SharedUniforms!
	private var _sharedUniformBuffer: MTLBuffer!
	
	private var _displayLink: CADisplayLink!
	
	private var _instantiateNodeQueue: [Component]!
	private var _deleteNodeQueue: [InternalComponent]!
	private var _transform: Transform!

	private var _indexCount: Int = 0
	
	//##############################################//
	//##########         PHYSICS         ###########//
	//##############################################//

	public var world: World
	private var count = 0
	
	//##############################################//
	//##############################################//

	var modelMatrix: float4x4 {
		return _transform.getModelMatrix()
	}

	public var cameraScale: float2 {
		return _transform.getScale()
	}

	public var cameraTranslation: float2 {
		return _transform.getPosition()
	}

	override init() {
		world = World(gravity: CGVectorMake(0.0, -9.8))
		
		_renderer = Renderer()
		_nodes = [Int: InternalComponent]()
		_instantiateNodeQueue = [Component]()
		_deleteNodeQueue = [InternalComponent]()
		_transform = Transform()

		let screenSize = Core.screenSize
		let screenScale = Core.screenScale

		_transform.setZPosition(-500.0)
		
		_projectionMatrix = newOrtho(
					-Float(screenSize.width/2.0)  * screenScale,
			right:   Float(screenSize.width/2.0)  * screenScale,
			bottom:	-Float(screenSize.height/2.0) * screenScale,
			top: 	 Float(screenSize.height/2.0) * screenScale,
			near: 	-1000,
			far: 	 1000
		)
		
		_viewMatrix = _transform.getModelMatrix()
		
		super.init()
		
		updateSharedUniformBuffer()
	}

	func setupGameLoop(metalLayer: CAMetalLayer) {
		_displayLink = CADisplayLink(target: self, selector: Selector("draw"))
		_displayLink.frameInterval = 1
		_displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

		_metalLayer = metalLayer
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
		self._nodes.updateValue(mutableComponent, forKey: index)
	}

	public func removeComponent(component: Component) {
		self._deleteNodeQueue.append(component as! InternalComponent)
	}
	
	internal func addNodeToInstantiate(node: Component) {
		self._instantiateNodeQueue.append(node)
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
		for nodeToInstantiate: Component in _instantiateNodeQueue {
			addComponent(nodeToInstantiate)
			if nodeToInstantiate is Physical {
				(nodeToInstantiate as! Physical).createInWorld(world)
			}
		}
		_instantiateNodeQueue.removeAll(keepCapacity: true)

		for nodeToDelete: InternalComponent in _deleteNodeQueue {
			if nodeToDelete is GameComponent {
				(nodeToDelete as! GameComponent).deleteRigidbody(world)
			}
			_nodes.removeValueForKey(nodeToDelete.index)
		}
		_deleteNodeQueue.removeAll(keepCapacity: true)

		world.step()

		for node: (Int, InternalComponent) in _nodes {
			node.1.update(_displayLink.duration)
		}
	}
	
	internal func draw() {
		update()

		guard let drawable = _metalLayer.nextDrawable() else {
			print("Error!! metalLayer.nextDrawable() fail")
			exit(1)
		}

		_renderer.startFrame(drawable: drawable)
		_renderer.renderCommandEncoder.setVertexBuffer(_sharedUniformBuffer, offset: 0, atIndex: 0)
		
		for node: (Int, InternalComponent) in _nodes {
			node.1.draw(_renderer)
		}
		
		_renderer.endFrame(drawable: drawable)
	}
}