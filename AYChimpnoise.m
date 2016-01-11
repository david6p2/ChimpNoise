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
            sharedInstance.deletedBeacons = [[NSMutableDictionary alloc] init];
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
    [self saveModel];
}

-(BOOL) deleteBeacon:(AYBeacon *) beacon{
    if([self.beacons objectForKey:beacon.key]){
        [self.beacons removeObjectForKey: beacon.key];
        [self addToDeletedBeacons:beacon];
        [self saveModel];
        return YES;
    }
    else{
        [self saveModel];
        return NO;
    }
}

#pragma mark - Beacons Array Methods
-(NSUInteger) beaconsCount{
    NSUInteger count = 0;
    NSArray *beacons = [self.beacons allValues];
    for (AYBeacon *beacon in beacons) {
        if ([self isMuted:beacon] == NO) {
            count = count + 1;
        }
    }
    return count;
}

-(NSArray *) beaconsArray{
    return [self.beacons allValues];
}

#pragma mark - Display Logic Methods
-(AYBeacon *) beaconToDisplayOnScreen{
    NSMutableArray *beaconsArray = [NSMutableArray arrayWithArray:[self beaconsArray]];
    while ([beaconsArray count] >0){
        NSUInteger randomIndex = arc4random() % [beaconsArray count];
        AYBeacon *beacon = beaconsArray[randomIndex];
        if (beacon.onScreen == NO && [self isMuted:beacon] == NO){
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

-(void) resetModel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:nil forKey:@"chimpnoise"];
}

#pragma mark - deletedBeacons
-(void) addToDeletedBeacons:(AYBeacon *)beacon{
    NSMutableDictionary *deletedBeacon = [self.deletedBeacons objectForKey:beacon.key];
    if (deletedBeacon == nil) {
        deletedBeacon = [[NSMutableDictionary alloc] init];
        [deletedBeacon setObject:[NSNumber numberWithInt:1] forKey:@"timesDeleted"];
        NSDate *createdAt = [NSDate date];
        [deletedBeacon setObject:createdAt forKey:@"createdAt"];
        [deletedBeacon setObject:createdAt forKey:@"updatedAt"];
        [self.deletedBeacons setObject:deletedBeacon forKey:beacon.key];
    }
    else{
        NSNumber *timesDeleted = [deletedBeacon objectForKey:@"timesDeleted"];
        NSNumber *newTimesDeleted = [NSNumber numberWithInt:[timesDeleted intValue] + 1];
        [deletedBeacon setObject:newTimesDeleted forKey:@"timesDeleted"];
        NSDate *updatedAt = [NSDate date];
        [deletedBeacon setObject:updatedAt forKey:@"updatedAt"];
    }
}

-(void) restartDeletedBeaconCount: (AYBeacon *)beacon{
    NSMutableDictionary *deletedBeacon = [self.deletedBeacons objectForKey:beacon.key];
    if (deletedBeacon != nil){
        NSNumber *newTimesDeleted = [NSNumber numberWithInt:0];
        [deletedBeacon setObject:newTimesDeleted forKey:@"timesDeleted"];
        NSDate *updatedAt = [NSDate date];
        [deletedBeacon setObject:updatedAt forKey:@"updatedAt"];
    }
}

-(BOOL) isMuted:(AYBeacon *)beacon{
    NSMutableDictionary *deletedBeacon = [self.deletedBeacons objectForKey:beacon.key];
    if (deletedBeacon == nil) {
        return NO;
    }
    NSNumber *timesDeleted = [deletedBeacon objectForKey:@"timesDeleted"];
    if ([timesDeleted intValue] < 3) {
        return NO;
    }
    else{
        return YES;
    }
}


@end
