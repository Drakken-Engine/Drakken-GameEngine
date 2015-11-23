//
//  MaterialManager.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 05/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import UIKit
import Metal
import MetalKit

public class MaterialManager: NSObject {
	
	private var materials: Dictionary<String, Material>!
	
	override init() {
		materials = Dictionary<String, Material>()
	}
	
	public func getMaterial(name: String) -> Material {
		if((materials[name]) != nil) {
			return materials[name]!
		}
		
		let material = Material(vertex: name + "_vertex", fragment: name + "_fragment")
		materials.updateValue(material, forKey: name)
		
		return material
	}
}
