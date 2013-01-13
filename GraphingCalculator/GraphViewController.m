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
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UIBarButtonItem *splitViewBarButtonItem;

@end

@implementation GraphViewController

@synthesize history = _history;
@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem {
    if (_splitViewBarButtonItem != barButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (barButtonItem) [toolbarItems insertObject:barButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = barButtonItem;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
    self.splitViewController.presentsWithGesture = NO;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    
    return UIInterfaceOrientationIsPortrait(orientation);
    
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc {
    
    barButtonItem.title = @"Calculator";
    self.splitViewBarButtonItem = barButtonItem;
    
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    self.splitViewBarButtonItem = nil;
}

- (void)setProgram:(id)program {
    _program = program;
    self.history.text = [CalculatorBrain descriptionOfProgram:self.program];
    [self.graphView setNeedsDisplay];
}

- (void)viewDidLoad {
    [self hideHistoryifPadLandscape];
    self.history.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    // Get scale and origin from userDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double originx = [defaults doubleForKey:@"originx"];
    double originy = [defaults doubleForKey:@"originy"];
    CGPoint origin = CGPointMake(originx, originy);
    double scale = [defaults doubleForKey:@"scale"];
    [self.graphView setScale:scale];
    [self.graphView setOrigin:origin];
    
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

- (NSNumber *)getYValForX:(double)x forGraphView:(GraphView *)sender {
    NSDictionary *variableValues = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"];
    id result = [CalculatorBrain runProgram:self.program usingVariables:variableValues];
    if ([result isKindOfClass:[NSNumber class]]) return result;
    return nil;
}

- (void)storeScale:(double)scale forGraphView:(GraphView *)sender {
    [[NSUserDefaults standardUserDefaults] setDouble:scale forKey:@"scale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeAxisOriginX:(double)x andAxisOriginY:(double)y forGraphView:(GraphView *)sender {
    [[NSUserDefaults standardUserDefaults] setDouble:x forKey:@"originx"];
    [[NSUserDefaults standardUserDefaults] setDouble:y forKey:@"originy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self hideHistoryifPadLandscape];
}

- (void)hideHistoryifPadLandscape {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) return;
    [self.history setHidden:UIInterfaceOrientationIsLandscape(self.interfaceOrientation)];
}

@end
