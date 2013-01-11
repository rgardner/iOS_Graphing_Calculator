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
    if (CGPointEqualToPoint(_origin, CGPointZero)) { // CGPointZero is a valid point, consider creating custom struct
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
    
    NSLog(@"Width: %f\nHeight: %f", self.bounds.size.width, self.bounds.size.height);
    
    BOOL lastSkipped = YES;
    CGContextBeginPath(context);
    for (CGFloat xPixel = 0; xPixel <= self.bounds.size.width; xPixel++) {
        double adjustedScale = self.scale * [self contentScaleFactor];
        double xAxisLength = self.bounds.size.width / adjustedScale;
        double minX = 0 - xAxisLength / 2;
        double xValue = minX + (xPixel / self.bounds.size.width) * xAxisLength;
        id yValue = [self.dataSource getYValForX:xValue forGraphView:self];
        
        if (!yValue) {
            lastSkipped = YES;
            continue;
        }
        
        double yAxisLength = self.bounds.size.height / adjustedScale;
        double minY = 0 - yAxisLength / 2;
        CGFloat yPixel = ([yValue doubleValue] - minY) / yAxisLength * self.bounds.size.height;
        
        if (lastSkipped) {
            CGContextMoveToPoint(context, xPixel, yPixel);
            lastSkipped = NO;
        } else {
            CGContextAddLineToPoint(context, xPixel, yPixel);
        }
    }

    [[UIColor blueColor] setStroke];
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 5.0);
}

@end
