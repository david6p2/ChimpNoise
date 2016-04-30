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

- (instancetype)initWithFrame:(CGRect)frame beacon:(Card *) beacon delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        if(beacon){
            [self setupWithBeacon:beacon];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(Card *) beacon delegate:(id)delegate{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = delegate;
        if(beacon){
            [self setupWithBeacon:beacon];
        }
    }
    return self;
}

- (void)setupWithBeacon:(Card *) beacon{
    [self cardSetup];
    
    self.beacon = beacon;
    
    self.cardTitle = self.beacon.title;
    self.cardPrompt = self.beacon.prompt;
    [self body];
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.beacon.type isEqualToString:@"url"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.beacon.url]];
    }
}


@end
