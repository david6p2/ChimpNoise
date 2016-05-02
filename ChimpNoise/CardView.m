//
//  CardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "CardView.h"

@implementation CardView

@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    CGFloat width  = frame.size.height * RATIO;
    CGFloat height = frame.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    return self;
}

-(void) cardSetup{
    
    // Shadow
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 3;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 1;

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Border
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    // Card Setup
    self.backgroundColor = [UIColor whiteColor];
}

+(CGFloat) cardRatio{
    return RATIO;
}

@end

