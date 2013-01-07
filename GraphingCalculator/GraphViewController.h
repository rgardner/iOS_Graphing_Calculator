//
//  GraphViewController.h
//  GraphingCalculator
//
//  Created by Bob Gardner on 1/6/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *history;
@property (strong, nonatomic) id program;

@end
