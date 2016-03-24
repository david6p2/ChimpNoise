//
//  ScanViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 3/22/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSwipeableView.h"
#import "RegionsScanner.h"
#import "NearBeaconsScanner.h"
#import "AYBeacon.h"
#import "BeaconCardView.h"

@interface ScanViewController : UIViewController <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, AYCardViewDelegate>

@property (strong, nonatomic) UIView *pulseView;
@property (strong, nonatomic) UIImageView *backgroundPulseView;
@property (strong, nonatomic) ZLSwipeableView *swipeableView;
@property (strong, nonatomic) RegionsScanner * regionsScanner;
@property (strong, nonatomic) NearBeaconsScanner *nearBeaconsScanner;

@end
