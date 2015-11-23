//
//  PointShader.metal
//  Underground_Survivors
//
//  Created by Allison Lindner on 18/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut
{
	float4 position		[[ position ]];
	float3 normal		[[ user(normal) ]];
	float2 texcoord		[[ user(tex_coord) ]];
	float4 color		[[ user(color) ]];
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

vertex VertexOut white_vertex ( constant	SharedUniforms	&sharedUniforms		[[ buffer(0) ]],
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
						float4(position[vid].xyz, 1.0);
	
	v_out.normal = normalize(modelUniforms.modelMatrix * float4(normal[vid], 0.0)).xyz;
	
	return v_out;
}

fragment float4 white_fragment (			VertexOut			vert		[[ stage_in ]],
								constant	Light				&light		[[ buffer(0) ]],
								constant	Material			&material	[[ buffer(1) ]],
								constant	float2				&texRepeat	[[ buffer(2) ]],
								constant	bool				&repeatMask	[[ buffer(3) ]],
											texture2d<float>	texture1	[[ texture(3) ]],
											texture2d<float>	texture2	[[ texture(4) ]],
											texture2d<float>	maskTexture	[[ texture(5) ]],
											sampler				s			[[ sampler(0) ]] )
{
	float4 color = float4(1.0, 1.0, 1.0, 1.0);
	
	return color;
}