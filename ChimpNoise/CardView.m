//
//  CardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "CardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon{
    self = [super initWithFrame:frame];
    if (self) {
        if(beacon){
            [self setupWithBeacon:beacon];
        }
        else{
            [self setup];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon{
    self = [super initWithCoder:aDecoder];
    if(beacon){
        [self setupWithBeacon:beacon];
    }
    else{
        [self setup];
    }
    return self;
}

- (void)setup {
    [self cardSetup];
    
    self.beacon = nil;
    
    [self addTitleLabel: @"Setup sin Beacon"];
    [self addImage: @"https://s-media-cache-ak0.pinimg.com/236x/20/a0/6a/20a06aed6797d0ffe0d6a524bd61cd1f.jpg"];
    [self addTimer];
}

- (void)setupWithBeacon:(AYBeacon *) beacon {
    [self cardSetup];
    
    self.beacon = beacon;
    
//    [self addTitleLabel: beacon.title];
    [self addImage: beacon.imageURL];
    [self addTimer];
}

-(void) addTitleLabel:(NSString *) title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/10)];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 10.0f/12.0f;
    titleLabel.clipsToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}

-(void) addImage:(NSString *) imageUrlString{
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 9/10);
    [imageView sd_setImageWithURL:[NSURL URLWithString: imageUrlString]
                 placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self addSubview:imageView];
}

-(void) addTimer{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   self.frame.size.height * 9/10,
                                                                   self.frame.size.width,
                                                                   self.frame.size.height * 1/10)];
    timeLabel.text = @"time remaining: 5:00";
    timeLabel.backgroundColor = [UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1.0];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.numberOfLines = 1;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.minimumScaleFactor = 10.0f/12.0f;
    timeLabel.clipsToBounds = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
}

-(void) cardSetup{
    
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Corner Radius
    self.layer.cornerRadius = 0;
    
    //Card Setup
    self.backgroundColor = [UIColor whiteColor];
}

@end

