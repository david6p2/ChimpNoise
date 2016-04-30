//
//  FirstViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZLSwipeableView.h"
#import "AYChimpnoise.h"
#import "CardView.h"
#import "BeaconCardView.h"
#import "TutorialCardView.h"
#import "BeaconListener.h"
#import "CardDeck.h"

@interface FirstViewController : UIViewController <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, CLLocationManagerDelegate, AYCardViewDelegate>

@property (nonatomic, strong) BeaconListener* beaconListener;
@property (nonatomic, strong) CardDeck* cardDeck;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIView *pulseView;
@property (strong, nonatomic) UIImageView *backgroundPulseView;
@property(nonatomic, assign) int AdIndex;
@property (nonatomic) AYChimpnoise *chimpnoise;
@property (nonatomic, strong) ZLSwipeableView *swipeableView;
@property (nonatomic, strong) CBCentralManager *bluetoothManager;

@end

