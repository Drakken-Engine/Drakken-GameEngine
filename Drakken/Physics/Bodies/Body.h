//
//  Body.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "World.h"
#import "BodyType.h"

@interface Body : NSObject

- (instancetype)initPosition:(CGPoint) position Radians:(float) radians BodyType:(BodyType) bodyType;
- (void) createBodyInWorld:(World *) world;

- (void) setUserDate:(void*) userData;
- (void) deleteBodyFromWorld:(World *) world;
- (void*) getBody;

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

@end
