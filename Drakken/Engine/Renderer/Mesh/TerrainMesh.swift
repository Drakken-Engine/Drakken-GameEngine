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

	private var positions: [float2] = [float2]()

	init(materialName: String, terrainVertices: [CGPoint] ) {
		id = TerrainMesh.idCount++

		super.init(shaderName: materialName)
		
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
		positions = [float2]()
		
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
			
			positions.append(	float2(	x: Float(point.x),
										y: Float(point.y))
							)

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

		_shader.setVertexData(float2: &positions, 	 length: sizeof(float2) * positions.count, 		index: 2)
		_shader.vertexCount = positions.count
	}
}
