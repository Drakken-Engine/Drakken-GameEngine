//
//  Fixture.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PolygonShape.h"
#import "Body.h"

@interface Fixture : NSObject

- (instancetype)initWithShape:(Shape *) shape Density:(float) density Friction:(float) friction Restitution:(float) restitution;
- (void) createForBody:(Body *) body;

@end