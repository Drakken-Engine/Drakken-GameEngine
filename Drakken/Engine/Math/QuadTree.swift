//
//  QuadTree.swift
//  HelloMetal
//
//  Created by Vinícius Godoy on 21/09/15.
//  Copyright © 2015 BEPiD. All rights reserved.
//

import Foundation
import CoreGraphics

internal protocol AxisAligned {
    var id : Int { get }
    var aabb : CGRect { get }
}

private class QuadNode<T : AxisAligned> {
	var MIN_SIZE = CGFloat(160.0);
	
	private var bounds : CGRect
    
    private var children : [QuadNode<T>]?
    private var objects : [T]?
    
	private init(bounds : CGRect, minSize: CGFloat) {
        self.bounds = bounds
		self.MIN_SIZE = minSize
    }
    
    private func hasMinimumSize() -> Bool {
        return bounds.height <= MIN_SIZE || bounds.width <= MIN_SIZE
    }
    
    private func subdivide() {
        let hw = bounds.width / 2.0
        let hh = bounds.height / 2.0
        
        let NW = CGRect(x: bounds.minX, y: bounds.minY, width: hw, height: hh)
        let NE = CGRect(x: bounds.minX + hw, y: bounds.minY, width: hw, height: hh)
        let SW = CGRect(x: bounds.minX, y: bounds.minY + hh, width: hw, height: hh)
        let SE = CGRect(x: bounds.minX + hw, y: bounds.minY + hh, width: hw, height: hh)
        children = [QuadNode<T>]()
        children!.append(QuadNode<T>(bounds: NW, minSize: MIN_SIZE))
        children!.append(QuadNode<T>(bounds: NE, minSize: MIN_SIZE))
        children!.append(QuadNode<T>(bounds: SE, minSize: MIN_SIZE))
        children!.append(QuadNode<T>(bounds: SW, minSize: MIN_SIZE))
        
        for child in children! {
            child.add(objects![0])
        }
        objects = nil
    }
    
    private func add(object : T) -> Bool {
        //Does not intersect? So can't add.
        if !CGRectIntersectsRect(bounds, object.aabb) {
            return false
        }
        
        //If intersects and hold no objects, add the object
        if objects == nil && children == nil {
            objects = [T]()
            objects!.append(object)
            return true
        }
        
        //A minumum sized node will hold any number of objects
        if objects != nil && hasMinimumSize() {
            objects!.append(object)
            return true
        }
        
        //If has no children and a second object is added, subdivide
        if children == nil {
            subdivide()
        }
        
        //Add the object to the children
        for child in children! {
            child.add(object)
        }
        return true
    }
    
    private func find(object : AxisAligned, inout result : [Int: T]) {
        if !CGRectIntersectsRect(bounds, object.aabb) {
            return
        }
        
        //If there are objects in this node, test if they colide.
        if objects != nil {
            for nodeObject in objects! {
                if CGRectIntersectsRect(object.aabb, nodeObject.aabb) {
                    result[nodeObject.id] = nodeObject
                }
            }
            return
        }
        
        //Otherwise, find if the children have colliding objects.
        if children != nil {
            for child in children! {
                child.find(object, result: &result)
            }
        }
    }
    
    private func remove(object : T) {
        if let previous = objects {
            objects = [T]();
            for obj in previous {
                if (obj.id != object.id) {
                    objects?.append(obj)
                }
			}
			
			if objects?.count == 0 {
				objects = nil
			}
        }
        
        if children != nil {
            for child in children! {
                child.remove(object)
            }
        }
    }
    
    private func all(inout result : [Int: T]) {
        if objects != nil {
            for nodeObject in objects! {
                result[nodeObject.id] = nodeObject
            }
        }
        
        if children != nil {
            for child in children! {
                child.all(&result)
            }
        }
    }
}

internal class QuadTree<T : AxisAligned> {
    private var root : QuadNode<T>
    
	internal init(size : CGRect, minSize: CGFloat) {
        root = QuadNode<T>(bounds: size, minSize: minSize)
    }
    
    internal func add(object: T) {
        root.add(object)
    }
    
    internal func find(object: AxisAligned) -> [T] {
        var result = [Int: T]()
        root.find(object, result: &result)
		return Array(result.map {
			res in res.1
		})
    }
    
    internal func values() -> [T] {
        var result = [Int: T]()
        root.all(&result)
		
		return Array(result.map {
			res in res.1
		})
    }
    
    internal func remove(object : T) {
        root.remove(object);
    }
}

