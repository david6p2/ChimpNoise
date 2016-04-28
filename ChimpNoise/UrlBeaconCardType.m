//
//  UrlBeaconCardType.m
//  ChimpNoise
//
//  Created by Andres Yepes on 1/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "UrlBeaconCardType.h"

@implementation UrlBeaconCardType

-(instancetype)initWithFrame:(CGRect)frame beacon:(Card *)beacon{
    self = [super initWithFrame:frame];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,
                                 0,
                                 self.frame.size.width,
                                 self.frame.size.height * 33/100);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGPathRef path = CGPathCreateWithRect(imageView.frame, NULL);
    maskLayer.path = path;
    CGPathRelease(path);

    imageView.layer.mask = maskLayer;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString: beacon.urlImage]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                               self.frame.size.height * 36/100,
                                                               self.frame.size.width - 40,
                                                               self.frame.size.height * 11/100)];
    title.text = beacon.urlTitle;
    title.font = [title.font fontWithSize:18];
    title.textColor = [UIColor colorWithRed:0.125 green:0.722 blue:0.902 alpha:1];
    title.backgroundColor = [UIColor whiteColor];
    title.numberOfLines = 2;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 10.0f/12.0f;
    title.clipsToBounds = YES;
    title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:title];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     self.frame.size.height * 46/100,
                                                                     self.frame.size.width - 40,
                                                                     self.frame.size.height * 26/100)];
    description.text = [NSString stringWithFormat:@"%@\n%@", beacon.urlDescription, beacon.url];
    description.font = [description.font fontWithSize:15];
    description.textColor = [UIColor grayColor];
    title.backgroundColor = [UIColor whiteColor];
    description.numberOfLines = 8;
    description.adjustsFontSizeToFitWidth = YES;
    description.minimumScaleFactor = 10.0f/12.0f;
    description.clipsToBounds = YES;
    description.textAlignment = NSTextAlignmentLeft;
    [self addSubview:description];
    
    UILabel *tapToLearnMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                             self.frame.size.height * 91/100,
                                                                             self.frame.size.width - 40,
                                                                             self.frame.size.height * 9/100)];
    tapToLearnMoreLabel.text = @"Tap to learn more";
    tapToLearnMoreLabel.font = [tapToLearnMoreLabel.font fontWithSize:12];
    //    tapToLearnMoreLabel.backgroundColor = [UIColor redColor];
    tapToLearnMoreLabel.textColor = [UIColor grayColor];
    tapToLearnMoreLabel.numberOfLines = 5;
    tapToLearnMoreLabel.adjustsFontSizeToFitWidth = YES;
    tapToLearnMoreLabel.minimumScaleFactor = 10.0f/12.0f;
    tapToLearnMoreLabel.clipsToBounds = YES;
    tapToLearnMoreLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:tapToLearnMoreLabel];
    
    return self;
}

@end
