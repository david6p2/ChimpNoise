//
//  FirstViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "FirstViewController.h"
#import "CardView.h"


#define BEACON_UUID_1 @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D"
#define BEACON_UUID_2 @"4D3B99C4-3857-D6C3-987A-BA2DA9C4AA19"


@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIView *deckView;

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
    
    //Init CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
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
    
    [self.locationManager startRangingBeaconsInRegion:region1];
    [self.locationManager startMonitoringForRegion:region1];
    
    [self.locationManager startRangingBeaconsInRegion:region2];
    [self.locationManager startMonitoringForRegion:region2];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init Chimpnoise Model
    self.chimpnoise = [AYChimpnoise sharedInstance];
    self.AdIndex = 0;
    [self displayAd];
    
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.deckView.frame];
    self.swipeableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];;
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    
    [self.view addSubview:self.swipeableView];

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
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
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
    [self displayAd];
    NSLog(@"%@", [self.chimpnoise beacons]);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitorDidFailForRegion");
    NSLog(@"with error: %ld ||| %@ ||| %@", error.code, error.domain, error.localizedDescription);
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
          translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    NSLog(@"nextViewForSwipeableView");
    
    CardView *view = [[CardView alloc] initWithFrame:CGRectMake(0, 0, swipeableView.frame.size.width - 50, swipeableView.frame.size.height - 50)];
    view.backgroundColor = [UIColor redColor];
    
    UIView *contentView =
    [[NSBundle mainBundle] loadNibNamed:@"CardView" owner:self options:nil][0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics =
    @{ @"height" : @(view.bounds.size.height),
       @"width" : @(view.bounds.size.width) };
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[contentView(width)]"
                          options:0
                          metrics:metrics
                          views:views]];
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[contentView(height)]"
                          options:0
                          metrics:metrics
                          views:views]];

    return view;

}

#pragma mark - helpers

- (void) displayAd{
    NSArray *beaconsToDisplay = [[self.chimpnoise beacons] allValues];
    if(beaconsToDisplay == nil || [beaconsToDisplay count] == 0){
        self.titleLabel.title = @"No Ads to show";
    }
    else{
        AYBeacon *displayBeacon = [beaconsToDisplay objectAtIndex:self.AdIndex];
        self.titleLabel.title = displayBeacon.title;
        self.titleLabel.prompt = displayBeacon.prompt;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:displayBeacon.imageURL]];
        self.imageView.image = [UIImage imageWithData:imageData];
    }
}

@end
