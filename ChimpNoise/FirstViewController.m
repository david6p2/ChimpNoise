//
//  FirstViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BEACON_UUID @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D"

@interface FirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) CLLocationManager *locationManager2;

@property (nonatomic) NSDictionary *placesByBeacons;

@property (weak, nonatomic) IBOutlet UINavigationItem *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FirstViewController
- (void)viewDidLoad {
    [super viewDidLoad];

//Init CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
//Show Dialog to approve Beacon Monitoring and Ranging
    [self.locationManager requestAlwaysAuthorization];
    
//Init Region
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                identifier:@"com.nsscreencast.beaconfun.region"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    
//start Monitoring
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager requestStateForRegion:region];
    
//Monkey Patch to range Beacon on Background
//    self.locationManager2 = [[CLLocationManager alloc] init];
//    self.locationManager2.delegate = self;
//    self.locationManager2.desiredAccuracy = kCLLocationAccuracyKilometer;
//    [self.locationManager2 startUpdatingLocation];

    
//------------------------------------------
    self.placesByBeacons = @{
                             @"1:1":@{
                                     @"title": @"Netshoes",
                                     @"prompt": @"Promotion 20% shoes",
                                     @"image": @"http://image.dhgate.com/albu_269291508_00/1.0x0.jpg"
                                     },
                             @"3:3":@{
                                     @"title": @"Iphone",
                                     @"prompt": @"50 USD off",
                                     @"image": @"http://www.sprint.com/landings/iphone-forever/images/iphone6s_lockup.jpg"
                                     }
                             };
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        NSLog(@"didDetermineState");
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertAction = @"See";
        notification.alertBody = @"Noise!";
        notification.alertTitle = @"Noise Title";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        NSLog(@"didEnterRegion");
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        NSLog(@"didExitRegion");
    }
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"didRangeBeacons");
    CLBeacon *nearestBeacon = (CLBeacon *)[beacons firstObject];
    NSString *beaconKey = [NSString stringWithFormat:@"%@:%@", nearestBeacon.major, nearestBeacon.minor];
    NSDictionary *nearestBeaconDetails = [self.placesByBeacons objectForKey:beaconKey];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[nearestBeaconDetails objectForKey:@"image"]]];
    self.imageView.image = [UIImage imageWithData:imageData];
    
    self.titleLabel.title = [nearestBeaconDetails objectForKey:@"title"];
    self.titleLabel.prompt = [nearestBeaconDetails objectForKey:@"prompt"];
    
}

#pragma mark - Utility Methods

@end
