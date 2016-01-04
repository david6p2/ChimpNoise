//
//  UrlBeaconCardType.m
//  ChimpNoise
//
//  Created by Andres Yepes on 1/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "UrlBeaconCardType.h"

@implementation UrlBeaconCardType

-(instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *)beacon{
    self = [super initWithFrame:frame];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,
                                 0,
                                 self.frame.size.width,
                                 self.frame.size.height * 33/100);
    [imageView sd_setImageWithURL:[NSURL URLWithString: beacon.imageURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                               self.frame.size.height * 36/100,
                                                               self.frame.size.width - 40,
                                                               self.frame.size.height * 11/100)];
    title.text = @"James tendría que pagar 50 mil euros en multas por incidente vial";
    title.font = [title.font fontWithSize:18];
    //    title.backgroundColor = [UIColor grayColor];
    title.textColor = [UIColor colorWithRed:0.125 green:0.722 blue:0.902 alpha:1];;
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
    description.text = @"El incidente de transito que protagonizó James Rodríguez el primer día de 2016 podría afectar la economía del colombiano.  Y es que según el diario ‘El Mundo’, de España, el ‘10’ tendría que pagar 50 mil euros sumando diferentes multas. \n\n www.futbolred.com";
    description.font = [description.font fontWithSize:15];
    //    description.backgroundColor = [UIColor redColor];
    description.textColor = [UIColor grayColor];
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
