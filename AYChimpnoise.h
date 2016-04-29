//
//  AYChimpnoise.h
//  ChimpNoise
//
//  Created by Andres Yepes on 10/27/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYBeacon.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "NSObject+RMArchivable.h"
#import "RMMapper.h"

@interface AYChimpnoise : NSObject <RMMapping>

@property (nonatomic, strong) NSMutableDictionary *beacons;

+ (AYChimpnoise *) sharedInstance;

-(AYBeacon *) findOrCreateBeaconWithUUID:(NSString *)uuid minor:(NSNumber *)minor major:(NSNumber *)major;
-(void) addBeacon:(AYBeacon *) beacon;
-(BOOL) deleteBeacon:(AYBeacon *) beacon;

-(NSUInteger) beaconsCount;
-(NSArray *) beaconsArray;

-(AYBeacon *) beaconToDisplayOnScreen;

-(void) hideAllBeacons;

@end
