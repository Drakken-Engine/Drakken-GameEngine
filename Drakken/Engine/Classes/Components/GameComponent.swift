//
// Created by Allison Lindner on 21/09/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd
import Metal

public class Script {
	public var component: GameComponent!
	public var transform: Transformable!
	public var rigidbody: RigidbodyProtocol!
	public var nodeDescriptor: Descriptor!

	public var deltaTime: CFTimeInterval = 0.0

	public func instantiateNode(node: Component) {
		component.scene.addComponentToInstantiate(node)
	}

	public func delete() {
		component.delete()
	}

	public init() {}
	
	public func start() {}
	public func update() {}
	public func onCollisionEnter	(other: OtherComponent, collisionPoint:(CGPoint)) {}
	public func onCollisionExit		(other: OtherComponent, collisionPoint:(CGPoint)) {}
	public func onCollisionEnterWithFluid		(descriptor: Descriptor) {}
	public func onCollisionEnterWithTerrain		(descriptor: Descriptor) {}
	public func onCollisionExitWithTerrain		(descriptor: Descriptor) {}
}

public class GameComponent: NSObject, InternalComponent, Component, Scriptable, Collidable, Physical {
	private var _children: [GameComponent]
	private var _scripts: [Script]!

	private var _rigidbody: Rigidbody!
	private(set) var _transform: Transform!
	private var _animator: Animator!

	private var _hasRigidbody: Bool = false
	internal var animated: Bool = false

	private var _mesh: Mesh

	public var rigidbody: RigidbodyProtocol!
	public var transform: Transformable!

	public var descriptor: Descriptor!
	public var hidden: Bool

	internal var index: Int = 0
	var scene: Scene!
	
	public var maskTexture: Texture {
		return _mesh.maskTexture
	}

	public var animator: Animator {
		return _animator
	}

	public convenience init(textureRepeatX: Int = 1, textureRepeatY: Int = 1) {
		self.init(materialName: "basic", textureRepeatX: textureRepeatX, textureRepeatY: textureRepeatY)
	}

	public init (materialName: String, textureRepeatX: Int = 1, textureRepeatY: Int = 1) {
		_transform = Transform()
		transform = _transform

		_rigidbody = Rigidbody(atPosition: CGPointMake(0.0, 0.0), radians: 0.0, bodyType: BodyType.Static)
		rigidbody = _rigidbody

		_scripts = [Script]()
		_children = [GameComponent]()

		_mesh = Grid(width: 2, height: 2, textureRepeatXCount: textureRepeatX, textureRepeatYCount: textureRepeatY)

		descriptor = Descriptor()
		hidden = false

		super.init()

		_animator = Animator(self)

		setMaskTexture(Texture(fileName: "white_pixel"))
	}
	
	internal func getComponent() -> InternalComponent {
		return self
	}

	public func delete() {
		hidden = true
		self.scene.removeComponent(self)
	}

	func setParentModelMatrix(parentModelMatrix: float4x4) {
		_transform.setParentModelMatrix(parentModelMatrix)
	}

	public func createInWorld(world: World) {
		_rigidbody?.createInWorld(world)
	}

	func deleteRigidbody(world: World) {
		_rigidbody?.deleteBodyFromWorld(world)
	}
	
	public func addRigibody(rigidbody: Rigidbody) {
		rigidbody.setNode(self)
		_transform.setRigidbody(rigidbody)

		_rigidbody = rigidbody
		_hasRigidbody = true
		self.rigidbody = _rigidbody
	}

	public func setAnimator(animator: Animator) {
		_animator = animator.copy()
		_animator.setComponent(self)
	}

    public func setMesh(mesh: Mesh) {
		_mesh = mesh
    }
	
	public func setTexture1(fileName file: String, fileExtension ext: String = ".png") {
		setTexture(texture1: Texture(fileName: file, fileExtension: ext))
	}

	public func setTexture2(fileName file: String, fileExtension ext: String = ".png") {
		setTexture(texture2: Texture(fileName: file, fileExtension: ext))
	}

	public func setTexture(texture1 texture: Texture) {
		_mesh.texture1 = texture
		_animator._defaultTexture = texture
	}

	public func setTexture(texture2 texture: Texture) {
		_mesh.texture2 = texture
	}

	public func setMaskTexture(texture: Texture) {
		_mesh.maskTexture = texture
	}
	
	public func setMaterial(materialName: String) {
		_mesh.setMaterial(materialName)
	}
	
	public func setTextureCoordOffset(offset: float2) {
		_mesh.texcoordsOffset = float2(	offset.x / _transform.getMeshScale().x,
										offset.y / _transform.getMeshScale().y)
	}

	public func addScript(script: Script) {
		script.transform = transform
		script.rigidbody = rigidbody
		script.nodeDescriptor = descriptor
		script.component = self

		script.start()
		_scripts.append(script)
    }

    public func addNode(node: GameComponent) {
		node.setParentModelMatrix(_transform.getModelMatrix())
		_children.append(node)
    }

	public func onCollisionEnter(other: OtherComponent, collisionPoint: CGPoint) {
		for script: Script in _scripts {
			script.onCollisionEnter(other, collisionPoint: collisionPoint)
		}
    }

    public func onCollisionExit(other: OtherComponent, collisionPoint: CGPoint) {
		for script: Script in _scripts {
			script.onCollisionExit(other, collisionPoint: collisionPoint)
		}
    }

	public func onCollisionEnterWithFluid(descriptor: Descriptor) {
		for script: Script in _scripts {
			script.onCollisionEnterWithFluid(descriptor)
		}
	}

	public func onCollisionEnterWithTerrain(descriptor: Descriptor) {
		for script: Script in _scripts {
			script.onCollisionEnterWithTerrain(descriptor)
		}
	}

	public func onCollisionExitWithTerrain(descriptor: Descriptor) {
		for script: Script in _scripts {
			script.onCollisionExitWithTerrain(descriptor)
		}
	}

	internal func updateWorldQuad(var worldQuad: [Int: [Int: [Component]]]) {
		if _rigidbody.getBodyType() != BodyType.Static {
			let x = Int(_transform.getPosition().x) / Int(kWorldQuadSize)
			let y = Int(_transform.getPosition().y) / Int(kWorldQuadSize)
			
			worldQuad[x]![y]!.append(self)
		}
	}

	public func update(deltaTime: CFTimeInterval) {
		if rigidbody != nil && _hasRigidbody {
			if rigidbody!.created {
				transform.setPosition(float2(	Float(rigidbody!.getPosition().x),
												Float(rigidbody!.getPosition().y)	))

				self.transform.setZRotationRadian(rigidbody!.getZRotation())
			}
		}
		
		for script: Script in _scripts {
			script.deltaTime = deltaTime
			script.update()
		}
		
		for child: InternalComponent in _children {
			child.update(deltaTime)
		}

		if animated {
			_animator.update(deltaTime)
		}
    }

	public func draw(renderer: Renderer) {
		if !hidden {
			if transform.getMeshScale().x > 0 && transform.getMeshScale().y > 0 {
				_mesh.drawMode = .Triangle
				_mesh.texture1 = _animator.getCurrentFrameTexture()
				_mesh.prepareToDraw(renderer, transform: _transform)
				_mesh.draw(renderer)
			}
			
			for child: InternalComponent in _children {
				child._transform.setParentModelMatrix(_transform.getModelMatrix())
				child.draw(renderer)
			}
		}
    }
}