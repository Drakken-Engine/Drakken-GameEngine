//
//  ExplosionPolygon.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 22/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation

public class ExplosionPolygon: AxisAligned {
	internal var id: Int
	internal var aabb: CGRect
	
	internal var polygon: [CGPoint]

	internal var position: CGPoint
	internal var radius: Int
	
	public init() {
		id = 0
		polygon = [CGPoint]()
		aabb = CGRect()

		position = CGPointZero
		radius = 0
	}
	
	internal func updateBounds() {
		var min: CGPoint = polygon[0]
		var max: CGPoint = polygon[0]
		
		for point in polygon {
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
		}
		
		//Define Rect for QuadTree
		aabb = CGRectMake(min.x, min.y, max.x - min.x, max.y - min.y)
	}
	
	public func generateCircle(radius: Float, precision: Int, position: CGPoint) -> ExplosionPolygon {
		for (var angle: Float = 0.0; angle < 360.0; angle = angle + (360.0/Float(precision))) {
			polygon.append(
				CGPointMake(
					CGFloat(cos(toRadians(Float(angle))) * radius) + position.x,
					CGFloat(sin(toRadians(Float(angle))) * radius) + position.y
				)
			)
		}
		
		let l = CGFloat(radius * 2.0)
		
		aabb = CGRectMake(position.x - (l/2.0), position.y - (l/2.0), l, l)

		self.position = position
		self.radius = Int(radius)

		return self
	}
	
	private func generateBoxPrivate(radius: Float, precision: Int, position: CGPoint, angleDegree: Float) -> ExplosionPolygon {
		
		for (var angle: Float = 0.0; angle < 360.0; angle = angle + (360.0/Float(precision))) {
			polygon.append(
				CGPointMake(
					CGFloat( cos(toRadians(Float(angleDegree - angle - 45))) * radius) + position.x,
					CGFloat( sin(toRadians(Float(angleDegree - angle - 45))) * radius) + position.y
				)
			)
		}
		
		updateBounds()
		
		return self
	}
	
	public func generateBox(size: CGFloat, position: CGPoint) -> ExplosionPolygon {
		polygon.append(CGPointMake(position.x - (size/2.0), position.y - (size/2.0)))
		polygon.append(CGPointMake(position.x + (size/2.0), position.y - (size/2.0)))
		polygon.append(CGPointMake(position.x + (size/2.0), position.y + (size/2.0)))
		polygon.append(CGPointMake(position.x - (size/2.0), position.y + (size/2.0)))
		
		aabb = CGRectMake(position.x - (size/2.0), position.y - (size/2.0), size, size)
		
		return self
	}
	
	public func generateBox(size: Float, position: CGPoint, angleDegree: Float) -> ExplosionPolygon {
		return generateBoxPrivate(size/1.4, precision: 4, position: position, angleDegree: angleDegree)
	}
}