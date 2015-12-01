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
	float4 position		[[ position ]];
	float3 normal		[[ user(normal) ]];
	float2 texcoord		[[ user(tex_coord) ]];
	float4 color			[[ user(color) ]];
	float  pointSize	[[ point_size ]];
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
							    constant	float3			*position			[[ buffer(2) ]],
							    constant	float3			*normal				[[ buffer(3) ]],
							    constant	float2			*texcoord			[[ buffer(4) ]],
							    constant	float4			*color				[[ buffer(5) ]],
							    constant	float			&pointSize			[[ buffer(6) ]],
							    constant	float2			*particlePositions	[[ buffer(7) ]],
							    uint						vid					[[ vertex_id ]])
{
	VertexOut v_out;
	
	v_out.position =	sharedUniforms.projectionMatrix *
						sharedUniforms.viewProjection *
						modelUniforms.modelMatrix *
						float4(position[vid], 1.0);
	
	v_out.normal = normalize(modelUniforms.modelMatrix * float4(normal[vid], 0.0)).xyz;
	v_out.texcoord = texcoord[vid];
	
	return v_out;
}

fragment float4 basic_fragment (			VertexOut			vert			[[ stage_in ]],
								constant	Light				&light		[[ buffer(0) ]],
								constant	Material			&material	[[ buffer(1) ]],
								constant	float2				&texRepeat	[[ buffer(2) ]],
								constant	bool				&repeatMask	[[ buffer(3) ]],
											texture2d<float>	texture1		[[ texture(3) ]],
											texture2d<float>	texture2		[[ texture(4) ]],
											texture2d<float>	maskTexture	[[ texture(5) ]],
											sampler				s			[[ sampler(0) ]] )
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
	
	float4 color = texture1.sample(s, texcoord);
	
	if(color.a == 0) {
		discard_fragment();
	}
	
	return color;
}