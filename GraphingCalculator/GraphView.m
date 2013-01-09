//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Bob Gardner on 1/6/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "GraphView.h"
#import "CalculatorBrain.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize origin = _origin;

#define DEFAULT_SCALE 15.0

- (CGFloat)scale {
    if (_scale) return _scale;
    return DEFAULT_SCALE;
}

- (void)setScale:(CGFloat)scale {
    if (scale == _scale) return;
    _scale = scale;
    [self setNeedsDisplay];
}

- (CGPoint)origin {
    if (CGPointEqualToPoint(_origin, CGPointZero)) {
        _origin.x = self.bounds.origin.x + self.bounds.size.width / 2;
        _origin.y = self.bounds.origin.y + self.bounds.size.height / 2;
    }
    return _origin;
}

- (void)setOrigin:(CGPoint)origin {
    if (CGPointEqualToPoint(origin, _origin)) return;
    _origin = origin;
    [self setNeedsDisplay];
}

- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];

    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    // calculate origin and scale
    // draw axes
    // draw graph
    // id program = [self.dataSource programForGraphView:self];
}

@end
