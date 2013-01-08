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
    self.history.text = [CalculatorBrain descriptionOfProgram:program];
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    // enable gestures
    self.graphView.dataSource = self;
}

-(id)programForGraphView:(GraphView *)sender {
    return [self.program copy];
}




@end
