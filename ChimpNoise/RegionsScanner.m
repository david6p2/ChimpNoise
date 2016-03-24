//
//  Regions.m
//  ChimpNoise
//
//  Created by Andres Yepes on 3/23/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "RegionsScanner.h"

@implementation RegionsScanner

- (id)init {
    self = [super init];
    if (self) {
        self.beaconManager = [ESTBeaconManager new];
        self.beaconManager.returnAllRangedBeaconsAtOnce = YES;
        self.regions = [NSMutableArray new];
    }
    return self;
}

-(instancetype) initWithDelegate:(id) delegate{
    RegionsScanner *new = [self init];
    new.beaconManager.delegate = delegate;
    return new;
}


-(ESTBeaconManager *)scan{
    [self initRegionWithUUID:BEACON_UUID_1 identifier:@"chimpnoise.one"];
    [self initRegionWithUUID:BEACON_UUID_2 identifier:@"chimpnoise.two"];
    [self initRegionWithUUID:BEACON_UUID_3 identifier:@"chimpnoise.three"];
    [self initRegionWithUUID:BEACON_UUID_4 identifier:@"chimpnoise.four"];
    [self initRegionWithUUID:BEACON_UUID_5 identifier:@"chimpnoise.five"];
    [self initRegionWithUUID:BEACON_UUID_6 identifier:@"chimpnoise.six"];
    [self initRegionWithUUID:BEACON_UUID_7 identifier:@"chimpnoise.seven"];
    [self initRegionWithUUID:BEACON_UUID_8 identifier:@"chimpnoise.eight"];
    [self initRegionWithUUID:BEACON_UUID_9 identifier:@"chimpnoise.nine"];
    [self initRegionWithUUID:BEACON_UUID_10 identifier:@"chimpnoise.ten"];
    [self initRegionWithUUID:BEACON_UUID_11 identifier:@"chimpnoise.eleven"];
    [self initRegionWithUUID:BEACON_UUID_12 identifier:@"chimpnoise.twelve"];
    [self initRegionWithUUID:BEACON_UUID_13 identifier:@"chimpnoise.thirteen"];
    [self initRegionWithUUID:BEACON_UUID_14 identifier:@"chimpnoise.fourteen"];
    [self initRegionWithUUID:BEACON_UUID_15 identifier:@"chimpnoise.fifteen"];
    [self initRegionWithUUID:BEACON_UUID_16 identifier:@"chimpnoise.sixteen"];
    [self initRegionWithUUID:BEACON_UUID_17 identifier:@"chimpnoise.seventeen"];
    [self initRegionWithUUID:BEACON_UUID_18 identifier:@"chimpnoise.eightteen"];
    [self initRegionWithUUID:BEACON_UUID_19 identifier:@"chimpnoise.nineteen"];
    [self initRegionWithUUID:BEACON_UUID_20 identifier:@"chimpnoise.twenty"];
    
    return self.beaconManager;
}

-(void) stopScan{
    for (CLBeaconRegion *region in self.regions) {
        [self.beaconManager stopRangingBeaconsInRegion:region];
    }
}

#pragma private

-(void) initRegionWithUUID:(NSString *)uuidString identifier:(NSString *) identifier{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    
    [self.beaconManager startRangingBeaconsInRegion:region];
    [self.beaconManager startMonitoringForRegion:region];
    
    [self.regions addObject:region];
}

@end
