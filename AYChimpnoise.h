//
//  AYChimpnoise.h
//  ChimpNoise
//
//  Created by Andres Yepes on 10/27/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYBeacon.h"

@interface AYChimpnoise : NSObject

@property (nonatomic, strong) NSMutableDictionary *beacons;

+ (AYChimpnoise *) sharedInstance;

-(void) addBeacon:(AYBeacon *) beacon;
-(AYBeacon *) findOrCreateBeaconWithUUID:(NSString *)uuid minor:(NSNumber *)minor major:(NSNumber *)major;
-(NSUInteger) beaconsCount;
-(NSArray *) beaconsArray;
-(AYBeacon *) beaconToDisplayOnScreen;
-(BOOL) deleteBeacon:(AYBeacon *) beacon;
@end
