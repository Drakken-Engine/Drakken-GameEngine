//
//  Utils.swift
//  Underground_Survivors
//
//  Created by Allison Lindner on 14/10/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import MetalKit

func inspect(obj: Any) {
	let type: Mirror = Mirror(reflecting:obj)
	
	print("Type of the object: \(type.subjectType)")
	print("Display style: \(type.displayStyle)")
	print("Description: \(type.description)")
	print("Number of Properties: \(type.children.count)")
	
	for child in type.children {
		print("Property: \(child.label!) Value: \(child.value) Type: \(child.value.dynamicType)")
	}
}

extension Component {
	func hasProperty(label: String) -> Bool {
		let type: Mirror = Mirror(reflecting: self)

		for child in type.children {
			if child.label == label {
				return true
			}
		}
		return false
	}
}

public func ... (left: Int, right: Int) -> [Int] {
	var array = [Int]()
	
	if left <= right {
		for var i = left; i <= right; i++ {
			array.append(i)
		}
	} else {
		for var i = left; i >= right; i-- {
			array.append(i)
		}
	}
	
	return array
}