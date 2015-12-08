//
//  Vertex.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import simd
import Metal

struct ParticlesPositions {
	var positions: UnsafeMutablePointer<Void>
	var length: Int

	init () {
		positions = UnsafeMutablePointer<Void>()
		length = 0
	}
}

struct SharedUniforms {
	var projectionMatrix:	float4x4
	var viewMatrix:			float4x4
};

struct ModelUniforms {
	var parentModelMatrix: 	float4x4
	var modelMatrix:		float4x4
};

struct MaterialProperties {
	var specularIntensity:	Float
	var shininess:			Float
};

struct LightProperties {
	var color:				float3
	var ambientIntensity:	Float
	var diffuseIntensity:	Float
	var direction:			float3
};