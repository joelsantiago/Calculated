//
//  CalculatedViewController.h
//  Calculated
//
//  Created by Joel Santiago on 3/3/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *miniDisplay;
@property (retain) IBOutlet UIButton *clearButton;
@property (nonatomic) int firstNumber;
@property (nonatomic) int secondNumber;
@property (nonatomic, copy) NSString *operation;

@end
