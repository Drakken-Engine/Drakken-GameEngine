//
//  BasicShader.metal
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut
{
	float4 position			[[ position ]];
	float3 normal			[[ user(normal) ]];
	float2 texcoord			[[ user(tex_coord) ]];
	float4 color				[[ user(color) ]];
	float  pointSize		[[ point_size ]];
};

struct SharedUniforms
{
	float4x4 projectionMatrix;
	float4x4 viewProjection;
};

struct ModelUniforms
{
	float4x4 modelMatrix;
};

struct Material {
	float specularIntensity;
	float shininess;
};

struct Light
{
	float3 color;
	float ambientIntensity;
	float diffuseIntensity;
	float3 direction;
};

vertex VertexOut basic_vertex ( constant	SharedUniforms	&sharedUniforms		[[ buffer(0) ]],
							    constant	ModelUniforms	&modelUniforms		[[ buffer(1) ]],
							    constant	float2			*position			[[ buffer(2) ]],
							    constant	float2			*texcoord			[[ buffer(3) ]],
							    uint						vid					[[ vertex_id ]])
{
	VertexOut v_out;
	
	v_out.position =	sharedUniforms.projectionMatrix *
						sharedUniforms.viewProjection *
						modelUniforms.modelMatrix *
						float4(position[vid], 0.0, 1.0);
	v_out.texcoord = texcoord[vid];
	
	return v_out;
}

fragment float4 basic_fragment (			VertexOut			vert				[[ stage_in ]],
								constant		float2				&texRepeat		[[ buffer(0) ]],
								constant		bool					&repeatMask		[[ buffer(1) ]],
								constant		float2				&texcoordOffset	[[ buffer(2) ]],
											texture2d<float>		texture1			[[ texture(0) ]],
											texture2d<float>		maskTexture		[[ texture(1) ]],
											sampler				s				[[ sampler(0) ]] )
{
	float2 texcoord = vert.texcoord;
	float2 mask_texcoord = vert.texcoord;

	if(!repeatMask) {
		mask_texcoord.x = mask_texcoord.x / texRepeat.x;
		mask_texcoord.y = mask_texcoord.y / texRepeat.y;
	}

	float4 maskColor = maskTexture.sample(s, mask_texcoord);
	if(maskColor.r <= 0.2) {
		discard_fragment();
	}
	
	float4 color = texture1.sample(s, float2(texcoord.x + texcoordOffset.x, texcoord.y + texcoordOffset.y));
	
	if(color.a == 0) {
		discard_fragment();
	}
	
	return color;
}