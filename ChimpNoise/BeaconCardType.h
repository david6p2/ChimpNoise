//
//  BeaconCardType.h
//  ChimpNoise
//
//  Created by Andres Yepes on 1/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYBeacon.h"
#import "Card.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BeaconCardType : UIView

-(instancetype) initWithFrame:(CGRect)frame beacon:(Card *)beacon;

@end
