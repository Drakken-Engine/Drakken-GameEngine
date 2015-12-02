//
//  Vertex.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import simd
import Metal

protocol ShaderVertexData {
	var positions:			[float3] { get set }
	var normals:				[float3] { get set }
	var texcoords:			[float2] { get set }
	var colors:				[float4] { get set }
	var pointSize:			Float	 { get set }
	var particlesPositions: MTLBuffer { get set }
};

protocol ShaderFragmentTextureData {
	var texture1:		Texture { get set }
	var texture2:		Texture { get set }
	var maskTexture:	Texture { get set }
}

protocol ShaderFragmentBufferData {
	var textureRepeat: float2 { get set }
	var texcoordsOffset:	float2 { get set }
	var repeatMask: Bool { get set }
}

struct ParticlesPositions {
	var positions: UnsafeMutablePointer<Void>
	var length: Int

	init () {
		positions = UnsafeMutablePointer<Void>()
		length = 0
	}
}

struct ShaderBuffers {
	var vertexBuffer: [DataBuffer]
	var textureBuffer: [TextureBuffer]
	var fragmentBuffer: [DataBuffer]

	var indexBuffer: IndexBuffer
	var vertexCount: Int

	init() {
		vertexBuffer = [DataBuffer] (count: 6, repeatedValue: DataBuffer(index: 8))
		
		textureBuffer = [TextureBuffer](count: 6, repeatedValue: TextureBuffer(texture: Texture(fileName: "black_pixel"), index: 8))
		
		textureBuffer[0] = TextureBuffer(texture: Texture(fileName: "black_pixel"), index: 0)
		textureBuffer[1] = TextureBuffer(texture: Texture(fileName: "black_pixel"), index: 1)
		textureBuffer[2] = TextureBuffer(texture: Texture(fileName: "black_pixel"), index: 2)
		textureBuffer[3] = TextureBuffer(texture: Texture(fileName: "black_pixel"), index: 3)
		textureBuffer[4] = TextureBuffer(texture: Texture(fileName: "black_pixel"), index: 4)
		textureBuffer[5] = TextureBuffer(texture: Texture(fileName: "white_pixel"), index: 5)

		fragmentBuffer = [DataBuffer] (count: 3, repeatedValue: DataBuffer(index: 8))
		
		var f2 = float2(0.0)
		fragmentBuffer[2] = DataBuffer(float2Data: &f2, length: sizeof(float2), index: 4)
		
		indexBuffer	= IndexBuffer(indexCount: 0)
		vertexCount = 0
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