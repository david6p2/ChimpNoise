//
//  ImageBeaconCardType.m
//  ChimpNoise
//
//  Created by Andres Yepes on 1/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "ImageBeaconCardType.h"

@implementation ImageBeaconCardType

-(instancetype) initWithFrame:(CGRect)frame beacon:(AYBeacon *)beacon{
    self = [super initWithFrame:frame];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 10/10);
    [imageView sd_setImageWithURL:[NSURL URLWithString: beacon.imageURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self addSubview:imageView];

    return self;
}
@end
