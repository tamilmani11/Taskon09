//
//  CircleProgressView.h
//  task_feb
//
//  Created by AEL5356 on 12/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleProgressView;

@interface CircleProgressView : UIView

@property (nonatomic, assign) int currentProgress;
@property (nonatomic, retain) UIColor *numberColor;
@property (nonatomic, retain) UIFont *numberFont;

@property (nonatomic, retain) UIColor *circleColor;
@property (nonatomic, assign) CGFloat circleBorderWidth;

- (void)update:(int)progress;

@end
