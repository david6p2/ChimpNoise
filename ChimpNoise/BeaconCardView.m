//
//  BeaconCardView.m
//  ChimpNoise
//
//  Created by Andres Yepes on 12/5/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "BeaconCardView.h"
#import "ImageBeaconCardType.h"
#import "UrlBeaconCardType.h"
#import "TextBeaconCardType.h"


@implementation BeaconCardView

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        if(beacon){
            [self setupWithBeacon:beacon];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon delegate:(id)delegate{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = delegate;
        if(beacon){
            [self setupWithBeacon:beacon];
        }
    }
    return self;
}

- (void)setupWithBeacon:(AYBeacon *) beacon{
    [self cardSetup];
    
    self.beacon = beacon;
    beacon.delegate = self; //AYBeaconDelegate Protocol
    self.cardTitle = self.beacon.title;
    self.cardPrompt = self.beacon.prompt;
    [self body];
    [self bringSubviewToFront:self.actionLabel];
}

-(void) body{
    if (self.beaconCardType) {
        [self.beaconCardType removeFromSuperview];
        self.beaconCardType = nil;
    }
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if(self.beacon.type == nil){
        self.beaconCardType = [[ImageBeaconCardType alloc] initWithFrame:frame beacon:self.beacon];
    }
    else if([self.beacon.type isEqualToString:@"url"]){
        self.beaconCardType = [[UrlBeaconCardType alloc] initWithFrame:frame beacon:self.beacon];
    }
    else if ([self.beacon.type isEqualToString:@"image"]){
        self.beaconCardType = [[ImageBeaconCardType alloc] initWithFrame:frame beacon:self.beacon];
    }
    else if ([self.beacon.type isEqualToString:@"text"]){
        self.beaconCardType = [[TextBeaconCardType alloc] initWithFrame:frame beacon:self.beacon];
    }
    [self addSubview: self.beaconCardType];
}

#pragma mark - AYBeaconDelegate
-(void)beaconUpdate{    
    if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateBackground) {
        if (self.beacon.localNotification == NO) {
            UILocalNotification *notification = [UILocalNotification new];
            notification.alertTitle = @"Chimpnoise";
            notification.alertBody = self.beacon.prompt;
            notification.alertAction = @"See Noise";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            [self.beacon showNotification];
        }
    }
    else{
        [self body];
        self.cardTitle = self.beacon.prompt;
        self.cardPrompt = self.beacon.title;
        [self.delegate topCardViewUpdate];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.beacon.type isEqualToString:@"url"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.beacon.url]];
    }
}


@end
