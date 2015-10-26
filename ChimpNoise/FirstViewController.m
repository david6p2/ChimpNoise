//
//  FirstViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BEACON_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"

@interface FirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *locationManager2;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;

@end

@implementation FirstViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Init CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
//    Show Dialog to approve Beacon Monitoring and Ranging
    [self.locationManager requestAlwaysAuthorization];
    
//    Init Region
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                identifier:@"com.nsscreencast.beaconfun.region"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    
//    start Monitoring
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager requestStateForRegion:region];
    
//    Monkey Patch to range Beacon on Background
    self.locationManager2 = [[CLLocationManager alloc] init];
    self.locationManager2.delegate = self;
    self.locationManager2.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager2 startUpdatingLocation];
//    ------------------------------------------

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
//        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
//        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertAction = @"Compra!";
        notification.alertBody = @"Aca si tenemos aguacate!";
        notification.alertTitle = @"Titulo";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
//        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
//        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertAction = @"Compra Chao!";
        notification.alertBody = @"Chao!";
        notification.alertTitle = @"Titulo Chao";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
    }
}



- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"Entraaa");
    for (CLBeacon *beacon in beacons) {
        NSLog(@"Ranging beacon: %@", beacon.proximityUUID);
        NSLog(@"%@ - %@", beacon.major, beacon.minor);
        NSLog(@"Range: %@", [self stringForProximity:beacon.proximity]);
        
        [self setColorForProximity:beacon.proximity];
        self.rangeLabel.text = [self stringForProximity:beacon.proximity];
        self.majorLabel.text = [@"major: " stringByAppendingString:[beacon.major stringValue]];
        self.minorLabel.text = [@"minor: " stringByAppendingString:[beacon.minor stringValue]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //Do nothing here, but enjoy ranging callbacks in background :-)
}

#pragma mark - Utility Methods

- (NSString *)stringForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:    return @"Unknown";
        case CLProximityFar:        return @"Far";
        case CLProximityNear:       return @"Near";
        case CLProximityImmediate:  return @"Immediate";
        default:
            return nil;
    }
}

- (void)setColorForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            self.view.backgroundColor = [UIColor whiteColor];
            self.rangeLabel.backgroundColor = [UIColor whiteColor];
            break;
            
        case CLProximityFar:
            self.view.backgroundColor = [UIColor yellowColor];
            self.rangeLabel.backgroundColor = [UIColor yellowColor];
            break;
            
        case CLProximityNear:
            self.view.backgroundColor = [UIColor orangeColor];
            self.rangeLabel.backgroundColor = [UIColor orangeColor];
            break;
            
        case CLProximityImmediate:
            self.view.backgroundColor = [UIColor redColor];
            self.rangeLabel.backgroundColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
}
@end
