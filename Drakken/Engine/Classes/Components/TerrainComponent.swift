//
//  TerrainComponent.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 22/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import simd
import RSClipperWrapper

@objc public class TerrainComponent: NSObject, InternalComponent, Component, Physical {
	
	private var _polygonsTree: QuadTree<TerrainMesh>!
	private var _polygonsToDraw: [Int:TerrainMesh]!
	private var _scripts: [Script]

	private var _explosionsQueue: [ExplosionPolygon]
	
	private var _world: World!
	private var _core: Core!
	private var _clipper: _Clipper!
	private var _gridScale: Int!
	private var _drawComponent: GameComponent!

	private(set) var _transform: Transform!

	public var transform: Transformable!
	public var descriptor: Descriptor!

	internal var index: Int = 0
	
	public init(maskTexture: Texture, world: World, texture1: Texture, gridScale: Int = 150) {
		_polygonsTree = QuadTree<TerrainMesh>(
		size: CGRectMake(
				CGFloat(-maskTexture.size.width),
				CGFloat(-maskTexture.size.height),
				CGFloat(2 * maskTexture.size.width),
				CGFloat(2 * maskTexture.size.height)
			), minSize: 100.0
		)

		_scripts = [Script]()
		_explosionsQueue = [ExplosionPolygon]()

		_drawComponent = GameComponent()
		_drawComponent.setMesh(Grid(width: 2, height: 2, textureRepeatXCount: 10, textureRepeatYCount: 8))
		_drawComponent.setTexture(texture1: texture1)
		_drawComponent.setMaskTexture(maskTexture)
		_drawComponent.transform.setMeshScale(float2(Float(maskTexture.size.width), Float(maskTexture.size.height)))

		_gridScale = gridScale
		_world = world
		_transform = Transform()
		transform = _transform

		descriptor = Descriptor()
		
		super.init()

		createWithMaskTexture(maskTexture)
	}
	
	internal func getComponent() -> InternalComponent {
		return self
	}

	public func createWithMaskTexture(texture: Texture) {
		let contours: NSArray = MaskTexture.getContoursFromMaskTexture(
			texture.texture, withGridSize: CGSizeMake(CGFloat(_gridScale), CGFloat(_gridScale))
		)

		let hW: CGFloat = CGFloat(texture.size.width) / 2.0
		let hH: CGFloat = CGFloat(texture.size.height) / 2.0

		var i = 0
		var j = 0
		for(i = 0; i < contours.count; i++) {
			var polygon = [CGPoint]();
			let contoursSlice = (contours.objectAtIndex(i) as! NSArray)
			for(j = 0; j < (contours.objectAtIndex(i) as! NSArray).count - 1; j++) {

				let point1: CGPoint = (contoursSlice.objectAtIndex(j) as! NSValue).CGPointValue()
				polygon.append(CGPointMake(point1.x - hW, point1.y - hH))

				let point2: CGPoint = (contoursSlice.objectAtIndex(j + 1) as! NSValue).CGPointValue()
				polygon.append(CGPointMake(point2.x - hW, point2.y - hH))
			}

			let point1: CGPoint = (contoursSlice.objectAtIndex(0) as! NSValue).CGPointValue()
			polygon.append(CGPointMake(point1.x - hW, point1.y - hH))

			let point2: CGPoint = (contoursSlice.objectAtIndex(j) as! NSValue).CGPointValue()
			polygon.append(CGPointMake(point2.x - hW, point2.y - hH))

			addMeshArray([polygon])
		}
	}

	public func setTexture(texture texture: Texture) {
		_drawComponent.setTexture(texture1: texture)
	}

	public func setTexture1(fileName file: String, fileExtension ext: String) {
		_drawComponent.setTexture1(fileName: file, fileExtension: ext)
	}

	public func setTexture2(fileName file: String, fileExtension ext: String) {
		_drawComponent.setTexture2(fileName: file, fileExtension: ext)
	}

	public func setMaskTexture(texture texture: Texture) {
		_drawComponent.setMaskTexture(texture)
	}

	public func setMaskTexture(fileName file: String, fileExtension ext: String) {
		_drawComponent.setMaskTexture(Texture(fileName: file, fileExtension: ext))
	}
	
	internal func addMeshArray(polygonArray: [[CGPoint]]) {
		for polygon in polygonArray {
			addMesh(polygon)
		}
	}

	internal func addMesh(polygon: [CGPoint]) {
		let polygonMesh: TerrainMesh = TerrainMesh(
				materialName: "white",
				terrainVertices: DistanceSimplifier(distance: 3.0).reduce(polygon)
		)
		polygonMesh.createInWorld(_world, node: self)

		_polygonsTree.add(polygonMesh)
	}
	
	public func addExplosion(explosionPolygon: ExplosionPolygon) {
		_explosionsQueue.append(explosionPolygon)
	}
	
	private func executeExplosion(explosionPolygon: ExplosionPolygon) {
		let terrainsToDestroy = _polygonsTree.find(explosionPolygon)

		for terrain: TerrainMesh in terrainsToDestroy {
			terrain.deleteRigidbody(_world)
			_polygonsTree.remove(terrain)
			
			let clipped = Clipper.differencePolygons([terrain.polygon], fromPolygons: [explosionPolygon.polygon])
			
			for clip in clipped {
				addMesh(clip)
			}
		}

		let texture = _drawComponent.maskTexture
		let maskTexture = MaskTexture.cropCircleAtPosition(
				explosionPolygon.position,
				withRadius: Int32(explosionPolygon.radius),
				fromMetalTexture: texture.texture
		)

		setMaskTexture(texture: maskTexture)
	}
	
	public func createInWorld(world: World) {
		let terrains = _polygonsTree.values()
		
		for terrainMesh: TerrainMesh in terrains {
			terrainMesh.createInWorld(world, node: self)
		}
	}
	
	internal func updateWorldQuad(var worldQuad: [Int: [Int: [Component]]]) {
	}
	
	internal func update(deltaTime: CFTimeInterval) {
		for explosion: ExplosionPolygon in _explosionsQueue {
			executeExplosion(explosion)
		}
		_explosionsQueue.removeAll()
	}
	
	internal func draw(renderer: Renderer) {
		_drawComponent.transform.setZPosition(transform.getZPosition())
		_drawComponent.draw(renderer)
	}
}