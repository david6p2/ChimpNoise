//
//  BeaconListener.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/29/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "BeaconListener.h"

@implementation BeaconListener

static BeaconListener *sharedInstance = nil;

#pragma mark - singleton
+ (BeaconListener *) sharedInstance{
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[BeaconListener alloc] init];

        }
        return(sharedInstance);
    }
}

-(instancetype)init{
    if (self = [super init]) {
        self.beaconManager = [ESTBeaconManager new];
        self.beaconManager.delegate = self;
        self.beaconManager.returnAllRangedBeaconsAtOnce = YES;
        self.beacons = [[NSArray alloc] init];
    }
    return self;
}

//Public
-(void) requestAlwaysAuthorization{
    [self.beaconManager requestAlwaysAuthorization];
}

-(BOOL) verifyAuthorization{
    while ([self.beaconManager isAuthorizedForMonitoring] == NO || [self.beaconManager isAuthorizedForRanging] == NO) {
        NSLog(@"Paila");
        [self.beaconManager requestWhenInUseAuthorization];
    }
    return YES;
}

-(void) startMonitoring{
    CLBeaconRegion *region1 = [self regionWithUUID:BEACON_UUID_1 identifier:@"chimpnoise.one"];
    CLBeaconRegion *region2 = [self regionWithUUID:BEACON_UUID_2 identifier:@"chimpnoise.two"];
    CLBeaconRegion *region3 = [self regionWithUUID:BEACON_UUID_3 identifier:@"chimpnoise.three"];
    CLBeaconRegion *region4 = [self regionWithUUID:BEACON_UUID_4 identifier:@"chimpnoise.four"];
    CLBeaconRegion *region5 = [self regionWithUUID:BEACON_UUID_5 identifier:@"chimpnoise.five"];
    CLBeaconRegion *region6 = [self regionWithUUID:BEACON_UUID_6 identifier:@"chimpnoise.six"];
    CLBeaconRegion *region7 = [self regionWithUUID:BEACON_UUID_7 identifier:@"chimpnoise.seven"];
    CLBeaconRegion *region8 = [self regionWithUUID:BEACON_UUID_8 identifier:@"chimpnoise.eight"];
    CLBeaconRegion *region9 = [self regionWithUUID:BEACON_UUID_9 identifier:@"chimpnoise.nine"];
    CLBeaconRegion *region10 = [self regionWithUUID:BEACON_UUID_10 identifier:@"chimpnoise.ten"];
    CLBeaconRegion *region11 = [self regionWithUUID:BEACON_UUID_11 identifier:@"chimpnoise.eleven"];
    CLBeaconRegion *region12 = [self regionWithUUID:BEACON_UUID_12 identifier:@"chimpnoise.twelve"];
    CLBeaconRegion *region13 = [self regionWithUUID:BEACON_UUID_13 identifier:@"chimpnoise.thirteen"];
    CLBeaconRegion *region14 = [self regionWithUUID:BEACON_UUID_14 identifier:@"chimpnoise.fourteen"];
    CLBeaconRegion *region15 = [self regionWithUUID:BEACON_UUID_15 identifier:@"chimpnoise.fifteen"];
    CLBeaconRegion *region16 = [self regionWithUUID:BEACON_UUID_16 identifier:@"chimpnoise.sixteen"];
    CLBeaconRegion *region17 = [self regionWithUUID:BEACON_UUID_17 identifier:@"chimpnoise.seventeen"];
    CLBeaconRegion *region18 = [self regionWithUUID:BEACON_UUID_18 identifier:@"chimpnoise.eightteen"];
    CLBeaconRegion *region19 = [self regionWithUUID:BEACON_UUID_19 identifier:@"chimpnoise.nineteen"];
    CLBeaconRegion *region20 = [self regionWithUUID:BEACON_UUID_20 identifier:@"chimpnoise.twenty"];
    
    [self.beaconManager startMonitoringForRegion:region1];
    [self.beaconManager startMonitoringForRegion:region2];
    [self.beaconManager startMonitoringForRegion:region3];
    [self.beaconManager startMonitoringForRegion:region4];
    [self.beaconManager startMonitoringForRegion:region5];
    [self.beaconManager startMonitoringForRegion:region6];
    [self.beaconManager startMonitoringForRegion:region7];
    [self.beaconManager startMonitoringForRegion:region8];
    [self.beaconManager startMonitoringForRegion:region9];
    [self.beaconManager startMonitoringForRegion:region10];
    [self.beaconManager startMonitoringForRegion:region11];
    [self.beaconManager startMonitoringForRegion:region12];
    [self.beaconManager startMonitoringForRegion:region13];
    [self.beaconManager startMonitoringForRegion:region14];
    [self.beaconManager startMonitoringForRegion:region15];
    [self.beaconManager startMonitoringForRegion:region16];
    [self.beaconManager startMonitoringForRegion:region17];
    [self.beaconManager startMonitoringForRegion:region18];
    [self.beaconManager startMonitoringForRegion:region19];
    [self.beaconManager startMonitoringForRegion:region20];
}

-(void) startRanging{
    CLBeaconRegion *region1 = [self regionWithUUID:BEACON_UUID_1 identifier:@"chimpnoise.one"];
    CLBeaconRegion *region2 = [self regionWithUUID:BEACON_UUID_2 identifier:@"chimpnoise.two"];
    CLBeaconRegion *region3 = [self regionWithUUID:BEACON_UUID_3 identifier:@"chimpnoise.three"];
    CLBeaconRegion *region4 = [self regionWithUUID:BEACON_UUID_4 identifier:@"chimpnoise.four"];
    CLBeaconRegion *region5 = [self regionWithUUID:BEACON_UUID_5 identifier:@"chimpnoise.five"];
    CLBeaconRegion *region6 = [self regionWithUUID:BEACON_UUID_6 identifier:@"chimpnoise.six"];
    CLBeaconRegion *region7 = [self regionWithUUID:BEACON_UUID_7 identifier:@"chimpnoise.seven"];
    CLBeaconRegion *region8 = [self regionWithUUID:BEACON_UUID_8 identifier:@"chimpnoise.eight"];
    CLBeaconRegion *region9 = [self regionWithUUID:BEACON_UUID_9 identifier:@"chimpnoise.nine"];
    CLBeaconRegion *region10 = [self regionWithUUID:BEACON_UUID_10 identifier:@"chimpnoise.ten"];
    CLBeaconRegion *region11 = [self regionWithUUID:BEACON_UUID_11 identifier:@"chimpnoise.eleven"];
    CLBeaconRegion *region12 = [self regionWithUUID:BEACON_UUID_12 identifier:@"chimpnoise.twelve"];
    CLBeaconRegion *region13 = [self regionWithUUID:BEACON_UUID_13 identifier:@"chimpnoise.thirteen"];
    CLBeaconRegion *region14 = [self regionWithUUID:BEACON_UUID_14 identifier:@"chimpnoise.fourteen"];
    CLBeaconRegion *region15 = [self regionWithUUID:BEACON_UUID_15 identifier:@"chimpnoise.fifteen"];
    CLBeaconRegion *region16 = [self regionWithUUID:BEACON_UUID_16 identifier:@"chimpnoise.sixteen"];
    CLBeaconRegion *region17 = [self regionWithUUID:BEACON_UUID_17 identifier:@"chimpnoise.seventeen"];
    CLBeaconRegion *region18 = [self regionWithUUID:BEACON_UUID_18 identifier:@"chimpnoise.eightteen"];
    CLBeaconRegion *region19 = [self regionWithUUID:BEACON_UUID_19 identifier:@"chimpnoise.nineteen"];
    CLBeaconRegion *region20 = [self regionWithUUID:BEACON_UUID_20 identifier:@"chimpnoise.twenty"];
    
    [self.beaconManager startRangingBeaconsInRegion:region1];
    [self.beaconManager startRangingBeaconsInRegion:region2];
    [self.beaconManager startRangingBeaconsInRegion:region3];
    [self.beaconManager startRangingBeaconsInRegion:region4];
    [self.beaconManager startRangingBeaconsInRegion:region5];
    [self.beaconManager startRangingBeaconsInRegion:region6];
    [self.beaconManager startRangingBeaconsInRegion:region7];
    [self.beaconManager startRangingBeaconsInRegion:region8];
    [self.beaconManager startRangingBeaconsInRegion:region9];
    [self.beaconManager startRangingBeaconsInRegion:region10];
    [self.beaconManager startRangingBeaconsInRegion:region11];
    [self.beaconManager startRangingBeaconsInRegion:region12];
    [self.beaconManager startRangingBeaconsInRegion:region13];
    [self.beaconManager startRangingBeaconsInRegion:region14];
    [self.beaconManager startRangingBeaconsInRegion:region15];
    [self.beaconManager startRangingBeaconsInRegion:region16];
    [self.beaconManager startRangingBeaconsInRegion:region17];
    [self.beaconManager startRangingBeaconsInRegion:region18];
    [self.beaconManager startRangingBeaconsInRegion:region19];
    [self.beaconManager startRangingBeaconsInRegion:region20];
}

-(void) stopRanging{
    [self.beaconManager stopRangingBeaconsInAllRegions];
}

-(NSArray *) beaconsInRange{
    return self.beacons;
}


//Private
-(CLBeaconRegion *) regionWithUUID:(NSString *)uuidString identifier:(NSString *) identifier{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    return region;
}

//ESTBeaconManagerDelegate
-(void)beaconManager:(id)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    self.beacons = beacons;
    NSLog(@"didRangeBeacon: %lu", [beacons count]);
}

-(void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region{
    NSLog(@"Enter Region");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterRegion" object:nil];
}

-(void)beaconManager:(id)manager didExitRegion:(CLBeaconRegion *)region{
    NSLog(@"Exit Region");
}

-(void)beaconManager:(id)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region{
    NSLog(@"didDetermineState");
}

-(void)beaconManager:(id)manager didStartMonitoringForRegion:(CLBeaconRegion *)region{
    NSLog(@"didStartMonitoring");
}

-(void)beaconManager:(id)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    NSLog(@"monitorDidFailForRegion");
    NSLog(@"with error: %ld ||| %@ ||| %@", error.code, error.domain, error.localizedDescription);
}

@end
