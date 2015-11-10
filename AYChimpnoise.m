//
//  AYChimpnoise.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/27/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "AYChimpnoise.h"

@implementation AYChimpnoise

static AYChimpnoise *sharedInstance = nil;

+ (AYChimpnoise *) sharedInstance{
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[AYChimpnoise alloc] init];
            sharedInstance.beacons = [[NSMutableDictionary alloc] init];
        }
        return(sharedInstance);
    }
}

-(void)addBeacon:(AYBeacon *)beacon{
    [self.beacons setObject:beacon
                     forKey:[NSString stringWithFormat:@"%@:%@:%@", beacon.uuid, beacon.major, beacon.minor]];
}

-(AYBeacon *)findOrCreateBeaconWithUUID:(NSString *)uuid minor:(NSNumber *)minor major:(NSNumber *)major{
    AYBeacon *beacon = [self.beacons objectForKey:[NSString stringWithFormat:@"%@:%@:%@", uuid, major, minor]];
    if (beacon == nil) {
        beacon = [[AYBeacon alloc] initWithUUID:uuid minor:minor major:major];
        [self addBeacon:beacon];
    }
    return beacon;
}

-(BOOL) deleteBeacon:(AYBeacon *) beacon{
    NSString *key = beacon.key;
    NSMutableDictionary *nBeacons = self.beacons;
    if([self.beacons objectForKey:beacon.key]){
        [self.beacons removeObjectForKey: beacon.key];
        return YES;
    }
    else{
        return NO;
    }
}

-(NSUInteger) beaconsCount{
    NSArray *beacons = [self.beacons allValues];
    if(beacons == nil || [beacons count] == 0){
        return 0;
    }
    else{
        return [beacons count];
    }
}

-(NSArray *) beaconsArray{
    return [self.beacons allValues];
}

-(AYBeacon *) beaconToDisplayOnScreen{
    for (AYBeacon *beacon in [self beaconsArray]) {
        if(beacon.onScreen == NO){
            return beacon;
        }
    }
    return nil;
}

-(void) hideAllBeacons{
    for (AYBeacon *beacon in [self beaconsArray]) {
        beacon.onScreen = NO;
    }
}

@end
