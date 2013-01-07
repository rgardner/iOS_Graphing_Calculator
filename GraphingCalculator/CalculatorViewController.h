//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Bob Gardner on 12/23/12.
//  Copyright (c) 2012 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *history;
@end
