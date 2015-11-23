//
//  Body.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "Body.h"
#import "b2Math.h"
#import "b2Settings.h"
#import "b2Body.h"
#import "b2World.h"
#import "GlobalHeader.h"
#import <Box2D/Box2D.h>

#import "Drakken/Drakken-Swift.h"

@implementation Body {
	b2Body * _body;
	b2BodyDef _bodyDef;
}

- (instancetype)initPosition:(CGPoint) position Radians:(float) radians BodyType:(BodyType) bodyType {
	if (self = [super init]) {
		_bodyDef = b2BodyDef();
		if(bodyType == BodyType::Dynamic) {
			_bodyDef.type = b2BodyType::b2_dynamicBody;
		} else if(bodyType == BodyType::Static) {
			_bodyDef.type = b2BodyType::b2_staticBody;
		} else if(bodyType == BodyType::Kinematic) {
			_bodyDef.type = b2BodyType::b2_kinematicBody;
		}
		_bodyDef.position.Set(position.x / kWorldScale, position.y / kWorldScale);
		_bodyDef.angle = radians;
		_bodyDef.gravityScale = 1.0f;
		_bodyDef.fixedRotation = false;
	}
	return self;
}

- (void) createBodyInWorld:(World *) world {
	b2World * _world = (b2World *)[world getWorld];
	_body = _world->CreateBody(&_bodyDef);
}

- (void) setUserDate:(void*) userData {
	_body->SetUserData(userData);
}

- (void) deleteBodyFromWorld:(World *) world {
	b2World * _world = (b2World *)[world getWorld];
	_world->DestroyBody(_body);
}

- (void*) getBody {
	return (void*) _body;
}

- (void) setPosition:(CGPoint) position {
	_body->SetTransform(b2Vec2(position.x / kWorldScale, position.y / kWorldScale), _body->GetAngle());
}

- (CGPoint) getPosition {
	return CGPointMake(_body->GetPosition().x * kWorldScale, _body->GetPosition().y * kWorldScale);
}

- (void) setZRotation:(float) rotation {
	_body->SetTransform(_body->GetPosition(), rotation);
}

- (float) getZRotation {
	return _body->GetAngle();
}

- (void) applyForce:(CGVector) force toCenterAndWake:(BOOL) wake {
	_body->ApplyForceToCenter(b2Vec2(force.dx, force.dy), wake);
}

- (void) applyForce:(CGVector) force toPoint:(CGPoint) point Wake:(BOOL) wake {
	_body->ApplyForce(b2Vec2(force.dx, force.dy), b2Vec2(point.x, point.y), wake);
}

- (void) applyLinearImpulse:(CGVector) impulse toPoint:(CGPoint) point Wake:(BOOL) wake {
	_body->ApplyLinearImpulse(b2Vec2(impulse.dx, impulse.dy), b2Vec2(point.x, point.y), wake);
}

- (void) applyTorque:(float) torque {
	_body->ApplyTorque(torque, true);
}

- (void) setLinearVelocity:(CGVector) velocity {
	_body->SetLinearVelocity(b2Vec2(velocity.dx, velocity.dy));
}

- (CGVector) getLinearVelocity {
	return CGVectorMake(_body->GetLinearVelocity().x, _body->GetLinearVelocity().y);
}

- (void) setAngularVelocity:(float) velocity {
	_body->SetAngularVelocity(velocity);
}

- (void) setLinearDamping:(float) damp {
	_body->SetLinearDamping(damp);
}

- (void) setAngularDamping:(float) damp {
	_body->SetAngularDamping(damp);
}

- (void) setGravityScale:(float) scale {
	_body->SetGravityScale(scale);
}

- (void) setBullet:(BOOL) flag {
	_body->SetBullet(flag);
}

- (void) setFixedRotation: (BOOL) flag {
	_body->SetFixedRotation(flag);
}

- (float) getMass {
	return _body->GetMass();
}

@end
