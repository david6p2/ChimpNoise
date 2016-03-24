//
//  NearBeaconsScanner.m
//  ChimpNoise
//
//  Created by Andres Yepes on 3/23/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "NearBeaconsScanner.h"

@implementation NearBeaconsScanner

- (id)init {
    self = [super init];
    if (self) {
        self.nearBeacons = [NSMutableArray new];
        self.nearBeaconsDictionary = [NSMutableDictionary new];
        self.index = 0;
    }
    return self;
}

#pragma mark - ESTBeaconManagerDelegate
- (void)beaconManager:(id)manager
      didRangeBeacons:(NSArray<CLBeacon *> *)beacons
             inRegion:(CLBeaconRegion *)region{
    NSLog(@"%@", beacons);
    self.nearBeacons = [NSMutableArray new];
    for (CLBeacon *clBeacon in beacons) {
        AYBeacon *ayBeacon = [self findOrCreateAyBeaconwithUUID:[clBeacon.proximityUUID UUIDString]
                                                          major:clBeacon.major
                                                          minor:clBeacon.minor];
        [self.nearBeacons addObject:ayBeacon];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nearBeaconsScannerEvent" object:self];
}

- (void)beaconManager:(id)manager
        didExitRegion:(CLBeaconRegion *)region{
    NSLog(@"++++++%@", region);
}

-(AYBeacon *) next{
    if([self.nearBeacons count] <= self.index){
        self.index = 0;
    }
    AYBeacon *beacon = [self.nearBeacons objectAtIndex:self.index];
    self.index++;
    return beacon;
}

-(AYBeacon *) findOrCreateAyBeaconwithUUID:(NSString *)uuid major:(NSNumber *) major minor:(NSNumber *) minor{
    NSString *key = [[NSString alloc] initWithFormat:@"%@:%@:%@", uuid, major, minor];
    AYBeacon *storedBeacon = [self.nearBeaconsDictionary objectForKey:key];
    if(storedBeacon == nil){
        storedBeacon = [[AYBeacon alloc] initWithUUID:uuid minor:minor major:major];
        [self.nearBeaconsDictionary setValue:storedBeacon forKey:key];
    }
    return storedBeacon;
}

@end
