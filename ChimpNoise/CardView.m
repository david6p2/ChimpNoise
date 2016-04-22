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
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
//    self.layer.borderColor = [UIColor colorWithRed:0 green:0.082 blue:0.141 alpha:1].CGColor;
//    self.layer.borderWidth = 1;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Corner Radius
    self.layer.cornerRadius = 0;
    
    // Card Setup
    self.backgroundColor = [UIColor whiteColor];
    
    //Action Label
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/ 10)];
    [self.actionLabel setFont:[self.actionLabel.font fontWithSize:40]];
    self.actionLabel.text = @"Delete";
    self.actionLabel.textColor = [UIColor whiteColor];
    self.actionLabel.alpha = 0;
    self.actionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.actionLabel];
    [self bringSubviewToFront:self.actionLabel];
}

-(void) updateNextActionLabel{
    [self updateActionLabelAlpha:0.7];
    self.actionLabel.text = @"Next";
    self.actionLabel.backgroundColor = [UIColor colorWithRed:0 green:0.082 blue:0.141 alpha:1];
}

-(void) updateDeleteActionLabel{
    [self updateActionLabelAlpha:0.7];
    self.actionLabel.text = @"Delete";
    self.actionLabel.backgroundColor = [UIColor colorWithRed:0 green:0.082 blue:0.141 alpha:1];
}

-(void) hideActionLabel{
    [self updateActionLabelAlpha:0];
    self.actionLabel.text = @"";
}

-(void) updateActionLabelAlpha:(CGFloat)alpha{
    [self.actionLabel setAlpha:alpha];
}

+(CGFloat) cardRatio{
    return RATIO;
}

@end

