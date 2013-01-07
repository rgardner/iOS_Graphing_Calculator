//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Bob Gardner on 12/23/12.
//  Copyright (c) 2012 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "float.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize variables = _variables;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain*)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        if ([digit doubleValue] == 0) {
            if ([self.display.text isEqualToString:@"0"]) return;
        } else {
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        self.display.text = digit;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateUserInterface];
}

- (IBAction)operationPressed:(UIButton*)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self.brain performOperation:sender.currentTitle];
    [self updateUserInterface];
}

- (IBAction)fractionPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text rangeOfString:@"."].location != NSNotFound) return;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else {
        self.display.text = @".";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed {
    [self.brain clearStack];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateUserInterface];
}

- (IBAction)backspacePressed {
    if (self.display.text.length == 0 || self.display.text.length == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    } else {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
    }
}

- (IBAction)signPressed {
    if ([self.display.text doubleValue] == 0) return;
    if ([self.display.text hasPrefix:@"-"]) {
        self.display.text = [self.display.text substringFromIndex:1];
    } else {
        self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
    }
    if (!self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
}

- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (self.display.text.length > 1) {
            [self backspacePressed];
            return;
        }
        self.userIsInTheMiddleOfEnteringANumber = NO;
    } else {
        [self.brain removeLastOperand];
    }
    [self updateUserInterface];
}


- (void)updateUserInterface {
    id result = [CalculatorBrain runProgram:[self.brain program]];
    if ([result isKindOfClass:[NSNumber class]]) {
        self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
    } else {
        self.display.text = result;
        [self.brain removeLastOperand];
    }
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}
@end
