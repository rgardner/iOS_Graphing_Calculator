//
//  GraphViewController.m
//  GraphingCalculator
//
//  Created by Bob Gardner on 1/6/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController

@synthesize history = _history;
@synthesize graphView = _graphView;
@synthesize program = _program;

-(void)setProgram:(id)program {
    _program = program;
    [self.graphView setNeedsDisplay];
}

-(void)viewDidLoad {
    self.history.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    // add pinch handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    // add pan handler
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    // add single finger triple tap handler
    UITapGestureRecognizer *singleFingerTTap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    singleFingerTTap.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:singleFingerTTap];

    self.graphView.dataSource = self;
}

-(NSNumber *)getYValForX:(double)x forGraphView:(GraphView *)sender {
    NSDictionary *variableValues = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"];
    id result = [CalculatorBrain runProgram:self.program usingVariables:variableValues];
    if ([result isKindOfClass:[NSNumber class]]) return result;
    return nil;
}

@end
