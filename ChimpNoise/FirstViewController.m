//
//  FirstViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AYChimpnoise.h"

#define BEACON_UUID_1 @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D"
#define BEACON_UUID_2 @"4D3B99C4-3857-D6C3-987A-BA2DA9C4AA19"


@interface FirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) CLLocationManager *locationManager2;

@property (nonatomic) NSDictionary *placesByBeacons;

@property (weak, nonatomic) IBOutlet UINavigationItem *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) AYChimpnoise *chimpnoise;

@end

@implementation FirstViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init Chimpnoise Model
    self.chimpnoise = [AYChimpnoise sharedInstance];
    
    //Init CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    
    //Init Gestures
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    //add the your gestureRecognizer , where to detect the touch..
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:leftRecognizer];
    
    //Init Region 1
    NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:BEACON_UUID_1];
    CLBeaconRegion *region1 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid1 identifier:@"chimpnoise.one"];
    region1.notifyOnEntry = YES;
    region1.notifyOnExit = YES;
    region1.notifyEntryStateOnDisplay = YES;

    //Init Region 2
    NSUUID *uuid2 = [[NSUUID alloc] initWithUUIDString:BEACON_UUID_2];
    CLBeaconRegion *region2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid2 identifier:@"chimpnoise.two"];
    region2.notifyOnEntry = YES;
    region2.notifyOnExit = YES;
    region2.notifyEntryStateOnDisplay = YES;
    
    //start Monitoring
    [self.locationManager startMonitoringForRegion:region1];
    [self.locationManager performSelector:@selector(requestStateForRegion:) withObject:region1 afterDelay:1];
    [self.locationManager performSelector:@selector(startMonitoringForRegion:) withObject:region2 afterDelay:2];
    [self.locationManager performSelector:@selector(requestStateForRegion:) withObject:region2 afterDelay:3];
    
    //Show Dialog to approve Beacon Monitoring and Ranging
    [self.locationManager requestAlwaysAuthorization];
    
    NSLog(@"viewDidLoad");
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {

    if (state == CLRegionStateInside) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSLog(@"didEnterRegion");
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        UILocalNotification *notification = [UILocalNotification new];
        
        if ([beaconRegion.identifier isEqualToString:@"chimpnoise.one"]) {
            notification.alertAction = @"See";
            notification.alertBody = @"Shoes Discount!";
            notification.alertTitle = @"Converse";
        }
        else {
            notification.alertAction = @"See";
            notification.alertBody = @"Iphone offer!";
            notification.alertTitle = @"Apple Store";
        }
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];

    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    NSLog(@"didExitRegion");
    
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"didRangeBeacons");
    NSLog(@"Region: %@", region.identifier);
    NSLog(@"# Beacons: %ld", [beacons count]);
    
    for (CLBeacon *beacon in beacons) {
        [self.chimpnoise findOrCreateBeaconWithUUID:[beacon.proximityUUID UUIDString]
                                                            minor:beacon.minor
                                                            major:beacon.major];
    }
	
    //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[nearestBeaconDetails objectForKey:@"image"]]];
    //        self.imageView.image = [UIImage imageWithData:imageData];
    NSLog(@"%@", [self.chimpnoise beacons]);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitorDidFailForRegion");
    NSLog(@"with error: %ld ||| %@ ||| %@", error.code, error.domain, error.localizedDescription);
}

#pragma mark - Gesture Methods
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"rightSwipeHandle");
    NSLog(@"%@", [[self.chimpnoise beacons] allValues]);
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"leftSwipeHandle");
    NSLog(@"%@", [[self.chimpnoise beacons] allValues]);
}

@end
