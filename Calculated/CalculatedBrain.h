//
//  CalculatedBrain.h
//  Calculated
//
//  Created by Joel Santiago on 3/3/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatedBrain : NSObject

- (void)pushValue:(double)operand;
- (double)popValue;
- (double)performOperation:(NSString *)operation;
- (NSString *)formatNumber:(NSString *)displayText;
- (void)restart;

@end
