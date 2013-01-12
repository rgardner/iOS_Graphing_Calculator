//
//  GraphView.h
//  GraphingCalculator
//
//  Created by Bob Gardner on 1/6/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource

- (NSNumber *)getYValForX:(double)x forGraphView:(GraphView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
@end
