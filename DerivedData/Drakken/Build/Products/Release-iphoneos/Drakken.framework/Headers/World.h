//
//  World.h
//  Underground_Survivors
//
//  Created by Allison Lindner on 14/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface World : NSObject

- (instancetype) initWithGravity:(CGVector) gravity;
- (void) setGravity:(CGVector) gravity;
- (void*) getWorld;
- (void) step;
- (void) step:(float) timeInterval;
- (void) destroy;

@end