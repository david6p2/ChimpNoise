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
    [self saveModel];
}

-(BOOL) deleteBeacon:(AYBeacon *) beacon{
    if([self.beacons objectForKey:beacon.key]){
        [self.beacons removeObjectForKey: beacon.key];
        [self saveModel];
        return YES;
    }
    else{
        [self saveModel];
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
    NSMutableArray *beaconsArray = [NSMutableArray arrayWithArray:[self beaconsArray]];
    while ([beaconsArray count] >0){
        NSUInteger randomIndex = arc4random() % [beaconsArray count];
        AYBeacon *beacon = beaconsArray[randomIndex];
        if (beacon.onScreen == NO){
            if (beacon.fetchFromServer == NO) {
                return beacon;
            }
            else{
                if (beacon.firstTimeOnScreen == YES) {
                    [beacon startCountdown];
                    return beacon;
                }
                else{
                    if (beacon.fetchFromServer == YES && [beacon expired] == YES) {
                        [self deleteBeacon:beacon];
                    }
                    else{
                        return beacon;
                    }
                }
            }
            [beaconsArray removeObjectAtIndex:randomIndex];
        }
    }
    return nil;
}

-(void) hideAllBeacons{
    for (AYBeacon *beacon in [self beaconsArray]) {
        beacon.onScreen = NO;
    }
}

#pragma mark - Persistance
-(void) saveModel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:self forKey:@"chimpnoise"];
}


@end
