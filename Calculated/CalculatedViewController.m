//
//  CalculatedViewController.m
//  Calculated
//
//  Created by Joel Santiago on 3/3/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import "CalculatedViewController.h"
#import "CalculatedBrain.h"

@interface CalculatedViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userPressedDot;
@property (nonatomic) BOOL userPressedOperation;
@property (nonatomic, strong) CalculatedBrain *brain;
@end

@implementation CalculatedViewController

@synthesize brain = _brain;

- (CalculatedBrain *)brain {
    if (!_brain) _brain = [[CalculatedBrain alloc] init];
    return _brain;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.display setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDelete:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDelete)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressDelete:)];
    
    [_clearButton addGestureRecognizer:tap];
    [_clearButton addGestureRecognizer:longPress];
    
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.display addGestureRecognizer:swipe];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    if ([self.display.text length] > 18) {
        return;
    }
        
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.brain formatNumber:[self.display.text stringByAppendingString:digit]];
//        self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
    
//        if ([self.miniDisplay.text isEqualToString:@"0"]) {
//            self.miniDisplay.text = digit;
//        } else {
//            self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:digit];
//        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    [_clearButton setTitle:@"DEL" forState:UIControlStateNormal];
}

- (IBAction)dotPressed {
    if (self.userPressedDot || [self.display.text length] > 18)
        return;
    
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = @"0.";
//        if (self.userPressedOperation) {
//            self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:@"0."];
//        } else {
//            self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:@"."];
//        }
    } else {
        self.display.text = [self.display.text stringByAppendingString:@"."];
//        self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:@"."];
    }

    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.userPressedDot = YES;
    self.userPressedOperation = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    self.operation = [sender currentTitle];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userPressedDot = NO;
    self.userPressedOperation = YES;
    
//    self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@ ", self.operation]];
    [self.brain pushValue:[[self.display.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]];
}


- (IBAction)modifierPressed:(UIButton *)sender {
    NSString *modifier = [sender currentTitle];
    double currVal = [self.display.text doubleValue];
    
    if ([modifier isEqualToString:@"+/-"]) {
        if ([self.display.text isEqualToString:@"0"]) {
            return;
        } else {
            self.display.text = [NSString stringWithFormat:@"%g", -currVal];
        }
    } else if ([modifier isEqualToString:@"%"]) {
        self.display.text = [NSString stringWithFormat:@"%g", currVal / 100];
    }
//    self.miniDisplay.text = self.display.text;
}

- (IBAction)tapDelete {
    if ([self.display.text length] > 1) {
        self.display.text = [self.brain formatNumber:[self.display.text substringToIndex:[self.display.text length] - 1]];
    } else if ([self.display.text length] == 1 && ![self.display.text  isEqual: @"0"]) {
        self.display.text = @"0";
        [_clearButton setTitle:@"C" forState:UIControlStateNormal];
    } else {
        return;
    }
}

- (IBAction)pressDelete:(UILongPressGestureRecognizer *)gestureRecognizer {
    self.display.text = @"0";
    
    [UIView setAnimationsEnabled:NO];
    [_clearButton setTitle:@"C" forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];
    
    self.userIsInTheMiddleOfEnteringANumber = self.userPressedDot = NO;
}


- (IBAction)swipeDelete:(UISwipeGestureRecognizer *)gestureRecognizer {
    if ([self.display.text length] > 1) {
        self.display.text = [self.brain formatNumber:[self.display.text substringToIndex:[self.display.text length] - 1]];
//        self.miniDisplay.text = [self.miniDisplay.text substringToIndex:[self.miniDisplay.text length] - 1];
    } else if ([self.display.text length] == 1 && ![self.display.text  isEqual: @"0"]) {
        self.display.text = @"0";
        [_clearButton setTitle:@"C" forState:UIControlStateNormal];
//        self.miniDisplay.text = [self.miniDisplay.text substringToIndex:[self.miniDisplay.text length] - 1];
    } else {
        return;
    }
}

- (IBAction)equalsPressed {
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        return;
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    [self.brain pushValue:[self.display.text doubleValue]];
    
    double result = [self.brain performOperation:self.operation];
    NSString *formattedResult = [self.brain formatNumber:[NSString stringWithFormat:@"%g", result]];
    self.display.text = [NSString stringWithFormat:@"%@", formattedResult];
//    self.miniDisplay.text = [NSString stringWithFormat:@"%g", result];
}

@end
