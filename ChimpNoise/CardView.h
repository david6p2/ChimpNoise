//
//  CardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYBeacon.h"

@interface CardView : UIView <AYBeaconDelegate>

@property (strong, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) AYBeacon *beacon;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
- (void)stopTimer;
- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon;
- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon;
@end



