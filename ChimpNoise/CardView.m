//
//  CardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
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
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2/10)];
    titleLabel.text = @"CardTitleLabeeeel";
    titleLabel.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 10.0f/12.0f;
    titleLabel.clipsToBounds = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    NSURL * imageURL = [NSURL URLWithString:@"http://www.gannett-cdn.com/-mm-/ac1394dbdcca6a36cbf486633b129cd813095ac3/r=x404&c=534x401/local/-/media/USATODAY/USATODAY/2012/09/30/kindle-paperwhite-4_3.jpg"];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, self.frame.size.height * 2/10, self.frame.size.width, self.frame.size.height * 7/10);
    [self addSubview:imageView];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 9/10, self.frame.size.width, self.frame.size.height * 1/10)];
    timeLabel.text = @"time remaining: 5:00";
    timeLabel.backgroundColor = [UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1.0];;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.numberOfLines = 1;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.minimumScaleFactor = 10.0f/12.0f;
    timeLabel.clipsToBounds = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];

}

@end

