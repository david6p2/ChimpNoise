//
//  BeaconCardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 12/5/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "AYChimpnoise.h"
#import "AYBeacon.h"
#import "BeaconCardType.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BeaconCardView : CardView <AYBeaconDelegate>

@property (strong, nonatomic) AYBeacon *beacon;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) BeaconCardType *beaconCardType;

- (void)stopTimer;
- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon delegate:(id) delegate;
- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon delegate:(id) delegate;

@end
