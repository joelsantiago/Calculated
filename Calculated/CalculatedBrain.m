//
//  CalculatedBrain.m
//  Calculated
//
//  Created by Joel Santiago on 3/3/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import "CalculatedBrain.h"

@interface CalculatedBrain()
@property (nonatomic, strong) NSMutableArray *valueStack;
@end

@implementation CalculatedBrain

@synthesize valueStack = _valueStack;

- (NSMutableArray *)valueStack {
    
    if (!_valueStack) {
        _valueStack = [[NSMutableArray alloc] init];
    }
    return _valueStack;
}

- (void)pushValue:(double)operand {
    
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.valueStack addObject:operandObject];
}

- (double)popValue {
    
    NSNumber *operandObject = [self.valueStack lastObject];
    if (operandObject) [self.valueStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation {
    
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popValue] + [self popValue];
    } else if ([operation isEqualToString:@"x"]) {
        result = [self popValue] * [self popValue];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popValue];
        result = [self popValue] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popValue];
        if (divisor) result = [self popValue] / divisor;
    }
    
    [self pushValue:result];
    
    return result;
}

- (void)restart {
    self.valueStack = nil;
}

- (NSString *)formatNumber:(NSString *)displayText {
    
    // Strips current commas from number for formatting then converts to NSNumber
    NSString *tempText = [displayText stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *newText = [NSNumber numberWithDouble:[tempText doubleValue]];
    
    // Reformats with commas
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *newDisplayText = [formatter stringFromNumber:newText];
    return newDisplayText;
}

@end
