    //
//  FirstViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "FirstViewController.h"

#define BEACON_UUID_1 @"0D24BE5C-FE93-707E-041E-CEFBCACA4D2D"
#define BEACON_UUID_2 @"4D3B99C4-3857-D6C3-987A-BA2DA9C4AA19"
#define BEACON_UUID_3 @"67DED150-E522-17B6-CB70-843903F8644B"



@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIView *deckView;

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
    
    //Init CLLocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
    [self initRegionWithUUID:BEACON_UUID_1 identifier:@"chimpnoise.one"];
    [self initRegionWithUUID:BEACON_UUID_2 identifier:@"chimpnoise.two"];
    [self initRegionWithUUID:BEACON_UUID_3 identifier:@"chimpnoise.three"];
    
    //Init CLLocationManager2 for Backgorund Range
    self.locationManagerBackground = [[CLLocationManager alloc] init];
    self.locationManagerBackground.delegate = self;
    self.locationManagerBackground.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManagerBackground startUpdatingLocation];
    
    //Init Chimpnoise Model
    AYChimpnoise *storedChimpnoise = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"chimpnoise"];
    
    if (storedChimpnoise) {
        self.chimpnoise = storedChimpnoise;
        [self.chimpnoise hideAllBeacons];
    }
    else{
        self.chimpnoise = [AYChimpnoise sharedInstance];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.deckView.frame];
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.backgroundColor = [UIColor whiteColor];
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    
    [self updateNumberOfBeacons];
    
    [self.view addSubview:self.swipeableView];
}



- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
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

    NSLog(@"didRangeBeacons %ld", [beacons count]);
    
    for (CLBeacon *beacon in beacons) {
        [self.chimpnoise findOrCreateBeaconWithUUID:[beacon.proximityUUID UUIDString]
                                              minor:beacon.minor
                                              major:beacon.major];
    }
    [self updateNumberOfBeacons];
    [self.swipeableView loadViewsIfNeeded];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitorDidFailForRegion");
    NSLog(@"with error: %ld ||| %@ ||| %@", error.code, error.domain, error.localizedDescription);
}
    
#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {

    if ([view class] == [CardView class]) {
        CardView *cardView = (CardView *) view;
        [cardView.beacon hide];
        
        if (direction == ZLSwipeableViewDirectionLeft) {
            [self deleteCard: cardView];
        }
        
        if (direction == ZLSwipeableViewDirectionRight) {
            [self skipCard: cardView];
        }
    }
    else if ([view class] == [TutorialCardView class]){
        TutorialCardView *tutorialCardView = (TutorialCardView *)view;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:tutorialCardView.key];
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    
    if (10 <= translation.x) {
        self.titleLabel.title = @"Next";
    }
    else if (translation.x <= -10){
        self.titleLabel.title = @"Delete";
    }
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    NSLog(@"nextViewForSwipeableView");
    
    CGRect frame = CGRectMake(0, 0, swipeableView.frame.size.width - 50, swipeableView.frame.size.height - 50);

    // 1. Display Tutorial.
    UIView *tutorial = [self displayTutorial:swipeableView frame:frame];
    if (tutorial){
        return tutorial;
    }
    
    // 2. If no tutorial to display then display beacon.
    UIView *beaconCardView = [self beaconCardViewToDisplay:swipeableView frame:frame];
    if (beaconCardView) {
        return beaconCardView;
    }
    
    // 3. If no beacon to display then return nil.
    return nil;
}

#pragma mark - Tutorial
-(UIView *) displayTutorial:(ZLSwipeableView *)swipeableView frame:(CGRect) frame{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"swipeRightTutorial"] == NO) {
        return [[TutorialCardView alloc] initWithFrame: frame
                                                   key: @"swipeRightTutorial"];
    }
    if ([defaults boolForKey:@"swipeLeftTutorial"] == NO) {
        return [[TutorialCardView alloc] initWithFrame: frame
                                                   key: @"swipeLeftTutorial"];
    }
    return nil;
}

#pragma mark - ChooseBeaconToDisplay
-(UIView *) beaconCardViewToDisplay:(ZLSwipeableView *)swipeableView frame:(CGRect)frame{
    AYBeacon * beaconToShow = [self.chimpnoise beaconToDisplayOnScreen];
    if (beaconToShow == nil) {
        [self updateNumberOfBeacons];
        [self.swipeableView loadViewsIfNeeded];
    }
    else{
        [beaconToShow display];
        CardView * cardView = [[CardView alloc] initWithFrame: frame beacon: beaconToShow];
        return cardView;
    }
    return nil;
}

#pragma mark - helpers
-(void) updateNumberOfBeacons{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"swipeRightTutorial"] == NO || [defaults boolForKey:@"swipeLeftTutorial"] == NO) {
        self.swipeableView.numberOfActiveViews = 1;
    }
    else{
        NSUInteger numberOfBeacons = [self.chimpnoise beaconsCount];
        if (numberOfBeacons >= 2) {
            self.swipeableView.numberOfActiveViews = 2;
            self.titleLabel.title = [[NSString alloc] initWithFormat:@"Noise (%ld)", numberOfBeacons];
        }
        else{
            self.swipeableView.numberOfActiveViews = numberOfBeacons;
            self.titleLabel.title = [[NSString alloc] initWithFormat:@"Noise (%ld)", numberOfBeacons];
        }
    }
}

-(void) initRegionWithUUID:(NSString *)uuidString identifier:(NSString *) identifier{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startRangingBeaconsInRegion:region];
    [self.locationManager startMonitoringForRegion:region];
}

#pragma mark - Card Swipes
-(void) deleteCard:(CardView *) view{

    BOOL eliminado = [self.chimpnoise deleteBeacon:view.beacon];
    if (eliminado) {
        [view stopTimer];
        self.titleLabel.title = @"Deleted!";
        [self updateNumberOfBeacons];
    }
    else{
        self.titleLabel.title = @"Card Not Found!";
    }
}

-(void) skipCard:(CardView *) view {
    [view stopTimer];
}

#pragma mark - Background Location Manager
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    //TODO
}


@end
