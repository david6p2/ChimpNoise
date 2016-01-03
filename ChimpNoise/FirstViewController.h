//
//  FirstViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZLSwipeableView.h"
#import "AYChimpnoise.h"
#import "CardView.h"
#import "ImageBeaconCardView.h"
#import "UrlBeaconCardView.h"
#import "TutorialCardView.h"


@interface FirstViewController : UIViewController <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, CLLocationManagerDelegate, AYCardViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *locationManagerBackground;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIView *pulseView;
@property (strong, nonatomic) UIImageView *backgroundPulseView;
@property(nonatomic, assign) int AdIndex;
@property (nonatomic) AYChimpnoise *chimpnoise;
@property (nonatomic, strong) ZLSwipeableView *swipeableView;

@end

