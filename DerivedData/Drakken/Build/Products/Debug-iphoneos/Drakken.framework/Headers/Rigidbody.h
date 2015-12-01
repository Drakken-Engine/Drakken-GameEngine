//
//  Rigidbody.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "World.h"
#import "BodyType.h"
#import "RigidbodyProtocol.h"

@protocol Collidable;
@protocol Physical;
@protocol OtherComponent;
@class OtherComponentAbstract;
@class Descriptor;

@interface Rigidbody : NSObject <RigidbodyProtocol>

@property (nonatomic) BOOL created;

- (instancetype) initAtPosition:(CGPoint) position
						Radians:(float) radians
					   BodyType:(BodyType) bodyType;

- (instancetype) initBoxAtPosition:(CGPoint) position
						   Radians:(float) radians
						  BodyType:(BodyType) bodyType
							  Size:(CGSize) size
						   Density:(float) density
						  Friction:(float) friction
					   Restitution:(float) restitution;

- (instancetype) initCircleAtPosition:(CGPoint) position
							   Center:(CGPoint) center
							   Radius:(float) radius
							  Radians:(float) radians
							 BodyType:(BodyType) bodyType
							  Density:(float) density
							 Friction:(float) friction
						  Restitution:(float) restitution;

- (instancetype) initEdgeAtPosition:(CGPoint) position
						withVector1:(CGPoint) v1
						 andVector2:(CGPoint) v2
							Radians:(float) radians
						   BodyType:(BodyType) bodyType
							Density:(float) density
						   Friction:(float) friction
						Restitution:(float) restitution;

- (void) addBoxFixtureWithSize:(CGSize) size
					   Density:(float) density
					  Friction:(float) friction
				   Restitution:(float) restitution;

- (void) addCicleFixtureWithCenter:(CGPoint) center
							Radius:(float) radius
						   Density:(float) density
						  Friction:(float) friction
					   Restitution:(float) restitution;

- (void) addEdgeFixtureWithVector1:(CGPoint) v1
						   Vector2:(CGPoint) v2
						   Density:(float) density
						  Friction:(float) friction
					   Restitution:(float) restitution;

- (void) createInWorld:(World *) world;
- (void) deleteBodyFromWorld:(World *) world;
- (void) setNode:(id<Physical>) node;
- (id<Physical>) getNode;
- (void)onCollisionEnter:(id<Physical>) other collisonPoint:(CGPoint) collisionPoint;
- (void)onCollisionExit:(id<Physical>) other collisonPoint:(CGPoint) collisionPoint;
- (void)onCollisionEnterWithFluid:(Descriptor *) descriptor;

- (void) setPosition:(CGPoint) position;
- (CGPoint) getPosition;

- (void) setZRotation:(float) rotation;
- (float) getZRotation;

- (void) applyForce:(CGVector) force toCenterAndWake:(BOOL) wake;
- (void) applyForce:(CGVector) force toPoint:(CGPoint) point Wake:(BOOL) wake;
- (void) applyLinearImpulse:(CGVector) impulse toPoint:(CGPoint) point Wake:(BOOL) wake;
- (void) applyTorque:(float) torque;

- (void) setLinearVelocity:(CGVector) velocity;
- (CGVector) getLinearVelocity;
- (void) setAngularVelocity:(float) velocity;
- (void) setLinearDamping:(float) damp;
- (void) setAngularDamping:(float) damp;
- (void) setGravityScale:(float) scale;
- (void) setBullet:(BOOL) flag;
- (void) setFixedRotation: (BOOL) flag;
- (float) getMass;
- (BodyType) getBodyType;

@end
