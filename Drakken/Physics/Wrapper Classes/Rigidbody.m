//
//  Rigidbody.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "Rigidbody.h"

#import "Body.h"
#import "Fixture.h"
#import "CircleShape.h"
#import "EdgeShape.h"

#import <Drakken/Drakken-Swift.h>

@implementation Rigidbody {
	Body * _body;
	NSMutableArray<Fixture *> * _fixtures;
	
	id<Physical> _node;
}

- (instancetype) initAtPosition:(CGPoint) position
						Radians:(float) radians
					   BodyType:(BodyType) bodyType {
	if (self = [super init]) {
		_body = [[Body alloc] initPosition:position
								   Radians:radians
								  BodyType:bodyType];
		
		_fixtures = [[NSMutableArray alloc] init];
		
		_created = false;
	}
	return self;
}

- (instancetype) initBoxAtPosition:(CGPoint) position
						   Radians:(float) radians
						  BodyType:(BodyType) bodyType
							  Size:(CGSize) size
						   Density:(float) density
						  Friction:(float) friction
					   Restitution:(float) restitution {
	if (self = [self initAtPosition:position
							Radians:radians
						   BodyType:bodyType]) {
		
		[self addBoxFixtureWithSize:size
							Density:density
						   Friction:friction
						Restitution:restitution];
	}
	return self;
}

- (instancetype) initCircleAtPosition:(CGPoint) position
							   Center:(CGPoint) center
							   Radius:(float) radius
							  Radians:(float) radians
							 BodyType:(BodyType) bodyType
							  Density:(float) density
							 Friction:(float) friction
						  Restitution:(float) restitution {
	
	if (self = [self initAtPosition:position
							Radians:radians
						   BodyType:bodyType]) {
		
		[self addCicleFixtureWithCenter:center
								 Radius:radius
								Density:density
							   Friction:friction
							Restitution:restitution];
	}
	return self;
}

- (instancetype) initEdgeAtPosition:(CGPoint) position
						withVector1:(CGPoint) v1
						 andVector2:(CGPoint) v2
							Radians:(float) radians
						   BodyType:(BodyType) bodyType
							Density:(float) density
						   Friction:(float) friction
						Restitution:(float) restitution {
	
	if (self = [self initAtPosition:position
							Radians:radians
						   BodyType:bodyType]) {
		
		[self addEdgeFixtureWithVector1:v1
								Vector2:v2
								Density:density
							   Friction:friction
							Restitution:restitution];
	}
	return self;
}

- (void) addBoxFixtureWithSize:(CGSize) size
					   Density:(float) density
					  Friction:(float) friction
				   Restitution:(float) restitution {
	
	PolygonShape * shape = [[PolygonShape alloc] init:size];
	Fixture * fixture = [[Fixture alloc] initWithShape:shape
											   Density:density
											  Friction:friction
										   Restitution:restitution];
	
	[_fixtures addObject:fixture];
}

- (void) addCicleFixtureWithCenter:(CGPoint) center
							Radius:(float) radius
						   Density:(float) density
						  Friction:(float) friction
					   Restitution:(float) restitution {
	
	CircleShape * shape = [[CircleShape alloc] init:center
											 Radius:radius];
	
	Fixture * fixture = [[Fixture alloc] initWithShape:shape
											   Density:density
											  Friction:friction
										   Restitution:restitution];
	
	[_fixtures addObject:fixture];
}

- (void) addEdgeFixtureWithVector1:(CGPoint) v1
						   Vector2:(CGPoint) v2
						   Density:(float) density
						  Friction:(float) friction
					   Restitution:(float) restitution {
	
	EdgeShape * shape = [[EdgeShape alloc] initWithVector1:v1
												andVector2:v2];
	
	Fixture * fixture = [[Fixture alloc] initWithShape:shape
											   Density:density
											  Friction:friction
										   Restitution:restitution];
	
	[_fixtures addObject:fixture];
}
				
- (void) createInWorld:(World *) world {
	[_body createBodyInWorld:world];
	
	for(Fixture * fixture in _fixtures) {
		[fixture createForBody:_body];
	}
	
	[_body setUserDate:(__bridge void *)self];
	_created = true;
}

- (void) deleteBodyFromWorld:(World *) world {
	[_body deleteBodyFromWorld:world];
}

- (void) setNode:(id<Physical>) node {
	_node = node;
}

- (id<Physical>) getNode {
	return _node;
}

- (id<OtherComponent>)createOtherWithInternalOther:(id<Physical>) internalOther {
	OtherComponentAbstract * _other = [[OtherComponentAbstract alloc] init];

	if([(NSObject *)internalOther isKindOfClass: [GameComponent class]]) {
		_other.rigidbody = ((GameComponent *) internalOther).rigidbody;
	}

	if([(NSObject *)internalOther conformsToProtocol: @protocol(Component)]) {
		_other.transform = ((id<Component>) internalOther).transform;
		_other.descriptor = ((id<Component>) internalOther).descriptor;
		_other.component = (id<Component>) internalOther;
	}

	return (id<OtherComponent>) _other;
}

- (void)onCollisionEnter:(id<Physical>) other collisonPoint:(CGPoint) collisionPoint {
	if([(NSObject *)_node conformsToProtocol: @protocol(Collidable)]) {
		if ([(NSObject *) other isKindOfClass:[GameComponent class]]) {
			id <OtherComponent> _other = [self createOtherWithInternalOther:other];
			[(id <Collidable>) _node onCollisionEnter:_other collisionPoint:collisionPoint];
		} else if ([(NSObject *) other isKindOfClass:[TerrainComponent class]]) {
			[(id <Collidable>) _node onCollisionEnterWithTerrain: ((id<Component>)other).descriptor];
		}
	}
}

- (void)onCollisionExit:(id<Physical>) other collisonPoint:(CGPoint) collisionPoint {
	if([(NSObject *)_node conformsToProtocol: @protocol(Collidable)]) {
		if ([(NSObject *) other isKindOfClass:[GameComponent class]]) {
			id <OtherComponent> _other = [self createOtherWithInternalOther:other];

			[(id <Collidable>) _node onCollisionExit:_other collisionPoint:collisionPoint];
		} else if ([(NSObject *) other isKindOfClass:[TerrainComponent class]]) {
			[(id <Collidable>) _node onCollisionExitWithTerrain: ((id<Component>)other).descriptor];
		}
	}
}

- (void)onCollisionEnterWithFluid:(Descriptor *) descriptor {
	if([(NSObject *)_node conformsToProtocol: @protocol(Collidable)]) {
		if ([(NSObject *) _node isKindOfClass:[GameComponent class]]) {
			[(id <Collidable>) _node onCollisionEnterWithFluid:descriptor];
		}
	}
}

- (void) setPosition:(CGPoint) position {
	[_body setPosition:position];
}

- (CGPoint) getPosition {
	return [_body getPosition];
}

- (void) setZRotation:(float) rotation {
	[_body setZRotation:rotation];
}

- (float) getZRotation {
	return [_body getZRotation];
}

- (void) applyForce:(CGVector) force toCenterAndWake:(BOOL) wake {
	[_body applyForce:force toCenterAndWake:wake];
}

- (void) applyForce:(CGVector) force toPoint:(CGPoint) point Wake:(BOOL) wake {
	[_body applyForce:force toPoint:point Wake:wake];
}

- (void) applyLinearImpulse:(CGVector) impulse toPoint:(CGPoint) point Wake:(BOOL) wake {
	[_body applyLinearImpulse:impulse toPoint:point Wake:wake];
}

- (void) applyTorque:(float) torque {
	[_body applyTorque:torque];
}

- (void) setLinearVelocity:(CGVector) velocity {
	[_body setLinearVelocity:velocity];
}

- (CGVector) getLinearVelocity {
	return [_body getLinearVelocity];
}

- (void) setAngularVelocity:(float) velocity {
	[_body setAngularVelocity:velocity];
}

- (void) setLinearDamping:(float) damp {
	[_body setLinearDamping:damp];
}

- (void) setAngularDamping:(float) damp {
	[_body setAngularDamping:damp];
}

- (void) setGravityScale:(float) scale {
	[_body setGravityScale:scale];
}

- (void) setBullet:(BOOL) flag {
	[_body setBullet:flag];
}

- (void) setFixedRotation: (BOOL) flag {
	[_body setFixedRotation:flag];
}

- (float) getMass {
	return [_body getMass];
}

- (BodyType) getBodyType {
	return [_body getBodyType];
}

@end