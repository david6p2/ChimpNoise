//
//  CardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYBeacon.h"

@interface CardView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) AYBeacon *beacon;
@property (weak, nonatomic) NSTimer *stopWatchTimer;
- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon delegate:(UIViewController *) delegate;
- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon;
@end
