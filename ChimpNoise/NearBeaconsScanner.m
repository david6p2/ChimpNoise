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
    }
    return self;
}


-(AYBeacon *) next{
    for (AYBeacon *beacon in self.nearBeacons) {
        if (beacon.onScreen == NO) {
            [beacon show];
            return beacon;
        }
    }
    return nil;
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
@end
