//
// Created by Allison Lindner on 03/10/15.
// Copyright (c) 2015 Allison Lindner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RigidbodyProtocol <NSObject>

@property (nonatomic) BOOL created;

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