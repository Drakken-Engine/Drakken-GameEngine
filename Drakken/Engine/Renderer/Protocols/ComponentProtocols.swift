//
// Created by Allison Lindner on 03/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd

@objc public protocol Collidable: NSObjectProtocol {
	func onCollisionEnter(other: OtherComponent, collisionPoint: CGPoint)
	func onCollisionExit(other: OtherComponent, collisionPoint: CGPoint)
	
	func onCollisionEnterWithFluid(descriptor: Descriptor)
	
	func onCollisionEnterWithTerrain(descriptor: Descriptor)
	func onCollisionExitWithTerrain(descriptor: Descriptor)
}

protocol Physical: NSObjectProtocol {
	func createInWorld(world: World)
}

protocol Scriptable: NSObjectProtocol {
	var scene: Scene! { get set }

	func addScript(script: Script)
}

@objc public protocol OtherComponent: NSObjectProtocol {
	var descriptor: Descriptor! { get set }

	var component: Component! { get set }
	var transform: Transformable! { get set }
	var rigidbody: RigidbodyProtocol? { get set }
}

internal protocol InternalComponent: NSObjectProtocol {
	var _transform: Transform! { get }
	
	var index: Int { get set }
	func getComponent() -> InternalComponent
	
	func update(deltaTime: CFTimeInterval)
	func draw(renderer: Renderer)
}

@objc public protocol Component: NSObjectProtocol {
	var descriptor: Descriptor! { get set }
	var transform: Transformable! { get set }
}

@objc public protocol Transformable: NSObjectProtocol {
	func setPosition(position: float2)
	func getPosition() -> float2

	func setZPosition(z: Float)
	func getZPosition() -> Float

	func setZRotationDegree(degree: Float)
	func getZRotationDegree() -> Float
	func setZRotationRadian(radian: Float)
	func getZRotationRadian() -> Float

	func setScale(scale: float2)
	func getScale() -> float2

	func setMeshScale(scale: float2)
	func getMeshScale() -> float2

	func setPivo(pivo: float2)
	func getPivo() -> float2
}