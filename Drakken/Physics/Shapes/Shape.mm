//
//  Shape.m
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import "Shape.h"
#import <Box2D/Box2D.h>

@implementation Shape {
	b2Shape * _shape;
}

- (void) setShape:(void *) shape {
	_shape = (b2Shape *) shape;
}

- (void *) getShape {
	return (void *) _shape;
}

@end
