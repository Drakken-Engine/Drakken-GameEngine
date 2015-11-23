//
//  Fluid.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 26/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "Fluid.h"
#import "ParticleSystem.h"
#import "ParticleGroup.h"
#import "PolygonShape.h"
#import "CircleShape.h"
#import "GlobalHeader.h"
#import "Drakken/Drakken-Swift.h"

@implementation Fluid {
	ParticleSystem * _particleSystem;
	id<Component> _component;
}

- (instancetype)initWithRadius:(float)radius
			   dampingStrength:(float)dampingStrength
				  gravityScale:(float)gravityScale
					   density:(float)density
						 world:(World *)world
					 component:(id<Component>)component
{
	self = [super init];
	if (self) {
		_particleSystem = [[ParticleSystem alloc] initWithRadius:radius / kWorldScale
												 dampingStrength:dampingStrength
													gravityScale:gravityScale
														 density:density
														   world:world];
		_component = component;
	}
	return self;
}

- (void) addWithShape:(Shape *) shape
		   atPosition:(CGPoint) position
			   ofType:(FluidType) type
{
	[ParticleGroup createWithShape:shape
						atPosition:CGPointMake(position.x / kWorldScale, position.y / kWorldScale)
							ofType:type
				 forParticleSystem:_particleSystem
						  userData:(__bridge void *) _component];
}

- (void) addBoxShapeFluidWithSize:(CGSize) size
					   atPosition:(CGPoint) position
						   ofType:(FluidType) type
{
	PolygonShape * boxShape = [[PolygonShape alloc] init:size];
	[self addWithShape:boxShape atPosition:position ofType:type];
}

- (void) addCircleShapeFluidWithRadius:(float) radius
							atPosition:(CGPoint) position
								ofType:(FluidType) type
{
	CircleShape * circleShape = [[CircleShape alloc] init:CGPointZero Radius:radius];
	[self addWithShape:circleShape atPosition:position ofType:type];
}

- (void *) getPositionBuffer {
	return [_particleSystem getPositionBuffer];
}

- (int) getParticleCount {
	return [_particleSystem getParticleCount];
}

@end
