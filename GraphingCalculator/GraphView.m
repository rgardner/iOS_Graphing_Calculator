//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Bob Gardner on 1/6/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale {
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale {
    if (scale == _scale) return;
    _scale = scale;
    [self setNeedsDisplay];
}

- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // calculate origin and scale
    // draw axes
    // draw graph
    // [AxesDrawer drawAxesInRect:<#(CGRect)#> originAtPoint:<#(CGPoint)#> scale:<#(CGFloat)#>]
    // id program = [self.dataSource programForGraphView:self];
}

@end
