//
//  CollisionListener.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#ifndef PHCollisionListener_h
#define PHCollisionListener_h

#include <stdio.h>
#include <Box2D/Box2D.h>
#import "b2WorldCallbacks.h"

class CollisionListener : public b2ContactListener {
public:
	CollisionListener();
	void BeginContact(b2Contact *contact);
	void EndContact(b2Contact *contact);

	void BeginContact(b2ParticleSystem* particleSystem, b2ParticleBodyContact* particleBodyContact);
};

#endif