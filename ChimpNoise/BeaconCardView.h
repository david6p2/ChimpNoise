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
#import <SDWebImage/UIImageView+WebCache.h>

@interface BeaconCardView : CardView <AYBeaconDelegate>

@property (strong, nonatomic) AYBeacon *beacon;
@property (strong, nonatomic) NSTimer *stopWatchTimer;

- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon delegate:(id) delegate;
- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon delegate:(id) delegate;
- (void)setupWithBeacon:(AYBeacon *) beacon;
- (void) addTimer;
- (void) startTimer;
- (void)stopTimer;
@end
