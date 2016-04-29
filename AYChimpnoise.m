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

#pragma mark - singleton
+ (AYChimpnoise *) sharedInstance{
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[AYChimpnoise alloc] init];
            sharedInstance.beacons = [[NSMutableDictionary alloc] init];
        }
        return(sharedInstance);
    }
}


#pragma mark - CRUD
-(AYBeacon *)findOrCreateBeaconWithUUID:(NSString *)uuid minor:(NSNumber *)minor major:(NSNumber *)major{
    AYBeacon *beacon = [self.beacons objectForKey:[NSString stringWithFormat:@"%@:%@:%@", uuid, major, minor]];
    if (beacon == nil) {
        beacon = [[AYBeacon alloc] initWithUUID:uuid minor:minor major:major];
        [self addBeacon:beacon];
    }
    return beacon;
}

-(void) addBeacon:(AYBeacon *)beacon{
    [self.beacons setObject:beacon
                     forKey:[NSString stringWithFormat:@"%@:%@:%@", beacon.uuid, beacon.major, beacon.minor]];
}

-(BOOL) deleteBeacon:(AYBeacon *) beacon{
    if([self.beacons objectForKey:beacon.key]){
        [self.beacons removeObjectForKey: beacon.key];
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - Beacons Array Methods
-(NSUInteger) beaconsCount{
    return [[self.beacons allValues] count];
}

-(NSArray *) beaconsArray{
    return [self.beacons allValues];
}

#pragma mark - Display Logic Methods
-(AYBeacon *) beaconToDisplayOnScreen{
    NSMutableArray *beaconsArray = [NSMutableArray arrayWithArray:[self beaconsArray]];
    while ([beaconsArray count] > 0){
        NSUInteger randomIndex = arc4random() % [beaconsArray count];
        AYBeacon *beacon = beaconsArray[randomIndex];
        
        if(beacon.onScreen == YES){
            continue;
        }
        
        return beacon;
        
    }
    return nil;
}

-(void) hideAllBeacons{
    for (AYBeacon *beacon in [self beaconsArray]) {
        beacon.onScreen = NO;
    }
}
@end
