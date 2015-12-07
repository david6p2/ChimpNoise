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

-(void) cardSetup{
    
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Corner Radius
    self.layer.cornerRadius = 0;
    
    // Card Setup
    self.backgroundColor = [UIColor whiteColor];
}

@end

