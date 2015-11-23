//
//  TerrainMesh.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 17/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import simd

class TerrainMesh: Mesh, AxisAligned {
	var id: Int
	var aabb: CGRect = CGRect()
	var polygon: [CGPoint]!
	
	private var rigidbody: Rigidbody!
	
	static var idCount = 0

	init(materialName: String, terrainVertices: [CGPoint] ) {
		id = TerrainMesh.idCount++

		super.init(materialName: materialName)
		
		updateVertices(terrainVertices)
		drawMode = .Line
	}
	
	convenience init(terrainVertices: [CGPoint] ) {
		self.init(materialName: "white", terrainVertices: terrainVertices)
	}
	
	func deleteRigidbody(world: World) {
		rigidbody.deleteBodyFromWorld(world)
	}
	
	func createInWorld(world: World, node: Physical) {
		rigidbody.createInWorld(world)
		rigidbody.setNode(node)
	}
	
	func updateVertices(terrainVertices: [CGPoint]) {
		rigidbody = Rigidbody(atPosition: CGPointMake(0.0, 0.0), radians: 0.0, bodyType: BodyType.Static)

		polygon = terrainVertices
		
		indices = [UInt32]()
		positions = [float3]()
		normals = [float3]()
		
		var min: CGPoint = terrainVertices[0]
		var max: CGPoint = terrainVertices[0]

		var lastPoint: CGPoint?
		for point in terrainVertices {
			//Min X
			if point.x <= min.x {
				min.x = point.x
			}
			//Min Y
			if point.y <= min.y {
				min.y = point.y
			}
			//Max X
			if point.x >= max.x {
				max.x = point.x
			}
			//Max Y
			if point.y >= max.y {
				max.y = point.y
			}
			
			positions.append(	float3(	x: Float(point.x),
										y: Float(point.y),
										z: 0.0))
			
			normals.append(		float3( x: 0.0,
										y: 0.0,
										z: 1.0))

			if lastPoint == nil {
				lastPoint = point
			} else {
				rigidbody.addEdgeFixtureWithVector1(
								 lastPoint!,
						vector2: point,
						density: 1.0, friction: 0.9, restitution: 0.0
				)

				lastPoint = point
			}
		}
		rigidbody.addEdgeFixtureWithVector1(
						 lastPoint!,
				vector2: terrainVertices[0],
				density: 1.0, friction: 0.9, restitution: 0.0
		)

		//Define Rect for QuadTree
		aabb = CGRectMake(min.x, min.y, max.x - min.x, max.y - min.y)
	}
}
