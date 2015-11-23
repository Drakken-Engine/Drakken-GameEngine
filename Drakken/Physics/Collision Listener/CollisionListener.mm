//
//  CollisionListener.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "CollisionListener.h"
#import "Rigidbody.h"

#import "GlobalHeader.h"
#import "b2Contact.h"
#import "b2Collision.h"
#import "b2Body.h"
#import "b2Fixture.h"
#import "b2Settings.h"
#import "b2ParticleSystem.h"
#import "b2ParticleGroup.h"

#import "Drakken/Drakken-Swift.h"

CollisionListener::CollisionListener() {
	
};

void CollisionListener::BeginContact(b2Contact *contact)
{
	b2Fixture *objectFixtureA = contact->GetFixtureA();
	b2Fixture *objectFixtureB = contact->GetFixtureB();
	
	b2WorldManifold worldManifold;
	contact->GetWorldManifold(&worldManifold);
	
	b2Body *objectBodyA = objectFixtureA->GetBody();
	b2Body *objectBodyB = objectFixtureB->GetBody();

	if(objectBodyA->GetUserData() != nullptr) {
		if(objectBodyB->GetUserData() != nullptr) {
			Rigidbody *rigidbodyB = (__bridge Rigidbody *) objectBodyB->GetUserData();
			Rigidbody *rigidbodyA = (__bridge Rigidbody *) objectBodyA->GetUserData();

			[rigidbodyA onCollisionEnter:[rigidbodyB getNode]
						  collisonPoint:CGPointMake(worldManifold.points[0].x * kWorldScale,
								  worldManifold.points[0].y * kWorldScale)];

			[rigidbodyB onCollisionEnter:[rigidbodyA getNode]
						  collisonPoint:CGPointMake(worldManifold.points[0].x * kWorldScale,
								  worldManifold.points[0].y * kWorldScale)];
		}
	}
};

void CollisionListener::EndContact(b2Contact *contact)
{
	b2Fixture *objectFixtureA = contact->GetFixtureA();
	b2Fixture *objectFixtureB = contact->GetFixtureB();
	
	b2WorldManifold worldManifold;
	contact->GetWorldManifold(&worldManifold);
	
	b2Body *objectBodyA = objectFixtureA->GetBody();
	b2Body *objectBodyB = objectFixtureB->GetBody();

	if(objectBodyA->GetUserData() != nullptr) {
		if(objectBodyB->GetUserData() != nullptr) {
			Rigidbody *rigidbodyB = (__bridge Rigidbody *) objectBodyB->GetUserData();
			Rigidbody *rigidbodyA = (__bridge Rigidbody *) objectBodyA->GetUserData();

			[rigidbodyA onCollisionExit:[rigidbodyB getNode]
						  collisonPoint:CGPointMake(worldManifold.points[0].x * kWorldScale,
								  worldManifold.points[0].y * kWorldScale)];

			[rigidbodyB onCollisionExit:[rigidbodyA getNode]
						  collisonPoint:CGPointMake(worldManifold.points[0].x * kWorldScale,
								  worldManifold.points[0].y * kWorldScale)];
		}
	}
};

void CollisionListener::BeginContact(b2ParticleSystem* particleSystem, b2ParticleBodyContact* particleBodyContact)
{
	b2Body * body = particleBodyContact->body;
	if(body != nullptr) {
		if(body->GetUserData() != nullptr) {
			Rigidbody *rigidbody = (__bridge Rigidbody *) body->GetUserData();

			b2ParticleGroup *_group = particleSystem->GetParticleGroupList();
			for (int i = 0; i <= particleSystem->GetParticleGroupCount(); i++) {
				if (_group->ContainsParticle(particleBodyContact->index)) {
					if (_group->GetUserData() != nullptr) {
						[rigidbody onCollisionEnterWithFluid:((__bridge id <Component>) _group->GetUserData()).descriptor];
						return;
					}
				}
				_group = _group->GetNext();
				if (_group == nullptr) {
					return;
				}
			}
		}
	}
}