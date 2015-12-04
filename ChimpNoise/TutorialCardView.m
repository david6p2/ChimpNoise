//
//  TutorialCardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 12/4/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "TutorialCardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TutorialCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self cardSetup];
        [self addTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                          key:(NSString *)key
                     imageURL:(NSString *)imageURL{
    self = [super initWithFrame:frame];
    if (self) {
        self.key = key;
        [self cardSetup];
        [self addImage: imageURL];
        [self addTimer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
                          key:(NSString *)key
                     imageURL:(NSString *)imageURL{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.key = key;
        [self cardSetup];
        [self addImage: imageURL];
        [self addTimer];
    }
    return self;
}

-(void) addImage:(NSString *) imageUrlString{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 9/10);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString: imageUrlString]
                      placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [self addSubview:self.imageView];
}

-(void) addTimer{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 9/10,
                                                               self.frame.size.width,
                                                               self.frame.size.height * 1/10)];
    self.timeLabel.text = @"Tutorial";
    self.timeLabel.backgroundColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.minimumScaleFactor = 10.0f/12.0f;
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
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
    
    // Card Setup
    self.backgroundColor = [UIColor whiteColor];
}

@end
