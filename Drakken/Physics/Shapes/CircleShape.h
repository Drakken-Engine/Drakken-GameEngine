//
//  CircleShape.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 15/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "Shape.h"

@interface CircleShape : Shape

- (instancetype) init:(CGPoint) center Radius:(float) radius;
- (instancetype) init:(float) radius;

@end
