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
	
	NSMutableArray * _shapesQueue;
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
		_shapesQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) addWithShape:(Shape *) shape
		   atPosition:(CGPoint) position
			   ofType:(FluidType) type
{
	NSMutableDictionary * shapeToAdd = [[NSMutableDictionary alloc] init];
	[shapeToAdd setObject:shape forKey:@"shape"];
	[shapeToAdd setObject:[NSValue valueWithCGPoint:position] forKey:@"position"];
	[shapeToAdd setObject:[NSValue valueWithPointer:&type] forKey:@"type"];
	
	[_shapesQueue addObject:shapeToAdd];
}

- (void) addWithShape:(Shape *) shape
		   atPosition:(CGPoint) position
			   ofType:(FluidType) type
			 lifetime:(float) lifetime
{
	NSMutableDictionary * shapeToAdd = [[NSMutableDictionary alloc] init];
	[shapeToAdd setObject:shape forKey:@"shape"];
	[shapeToAdd setObject:[NSValue valueWithCGPoint:position] forKey:@"position"];
	[shapeToAdd setObject:[NSValue valueWithPointer:&type] forKey:@"type"];
	[shapeToAdd setObject:[NSNumber numberWithFloat:lifetime] forKey:@"lifetime"];
	
	[_shapesQueue addObject:shapeToAdd];
}

- (void) addBoxShapeFluidWithSize:(CGSize) size
					   atPosition:(CGPoint) position
						   ofType:(FluidType) type
{
	PolygonShape * boxShape = [[PolygonShape alloc] init:size];
	[self addWithShape:boxShape atPosition:position ofType:type];
}

- (void) addBoxShapeFluidWithSize:(CGSize) size
					   atPosition:(CGPoint) position
						   ofType:(FluidType) type
						 lifetime:(float) lifetime
{
	PolygonShape * boxShape = [[PolygonShape alloc] init:size];
	[self addWithShape:boxShape atPosition:position ofType:type lifetime:lifetime];
}

- (void) addCircleShapeFluidWithRadius:(float) radius
							atPosition:(CGPoint) position
								ofType:(FluidType) type
{
	CircleShape * circleShape = [[CircleShape alloc] init:CGPointZero Radius:radius];
	[self addWithShape:circleShape atPosition:position ofType:type];
}

- (void) addCircleShapeFluidWithRadius:(float) radius
							atPosition:(CGPoint) position
								ofType:(FluidType) type
							  lifetime:(float) lifetime
{
	CircleShape * circleShape = [[CircleShape alloc] init:CGPointZero Radius:radius];
	[self addWithShape:circleShape atPosition:position ofType:type lifetime:lifetime];
}

- (void *) getPositionBuffer {
	return [_particleSystem getPositionBuffer];
}

- (int) getParticleCount {
	return [_particleSystem getParticleCount];
}

- (void) update {
	for(int i = 0; i < _shapesQueue.count; i++) {
		NSDictionary * info = [_shapesQueue objectAtIndex:i];
		
		Shape * shape = [info objectForKey:@"shape"];
		CGPoint position = [[info objectForKey:@"position"] CGPointValue];
		FluidType type = (FluidType)[[info objectForKey:@"type"] pointerValue];
		
		if([info objectForKey:@"lifetime"] == NULL) {
			[ParticleGroup createWithShape:shape
								atPosition:CGPointMake(position.x / kWorldScale, position.y / kWorldScale)
									ofType:type
						 forParticleSystem:_particleSystem
								  userData:(__bridge void *) _component];
		} else {
			float lifetime = [[info objectForKey:@"lifetime"] floatValue];
			
			[ParticleGroup createWithShape:shape
								atPosition:CGPointMake(position.x / kWorldScale, position.y / kWorldScale)
									ofType:type
						 forParticleSystem:_particleSystem
								  userData:(__bridge void *) _component
								  lifetime:lifetime];
		}
	}
	
	[_shapesQueue removeAllObjects];
}

- (void) removeAll {
	[_particleSystem removeAll];
}

@end
