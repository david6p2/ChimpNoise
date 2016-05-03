    //
//  FirstViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 10/17/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "FirstViewController.h"


#define SWIPEABLE_RATIO 0.86

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Init BeaconListener
    self.beaconListener = [BeaconListener sharedInstance];
    [self.beaconListener requestAlwaysAuthorization];
    [self.beaconListener startMonitoring];
    [self.beaconListener startRanging];
    
    self.cardDeck = [CardDeck sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2
                                                  target: self
                                                selector:@selector(updateNumberOfBeacons)
                                                userInfo: nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterRegion)
                                                 name:@"enterRegion"
                                               object:nil];
    [self initSwipeableView];
    [self updateNumberOfBeacons];
    [self initPulse];
}

- (void)viewDidLayoutSubviews {
    [self updateNavBar];
}

    
#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {

    if ([view class] == [BeaconCardView class]) {
        BeaconCardView *cardView = (BeaconCardView *) view;
        [cardView.beacon hide];
        
        if (direction == ZLSwipeableViewDirectionLeft) {
            [self skipCard: cardView];
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

-(void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view{
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location translation:(CGPoint)translation {
    if (10 <= translation.x) {
        //TODO NEXT
    }
    else if (translation.x <= -10){
        //TODO DELETE
    }
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    NSLog(@"nextViewForSwipeableView");
    
    CGFloat height = swipeableView.frame.size.height * SWIPEABLE_RATIO;
    CGFloat width  = height * [CardView cardRatio];
    CGRect frame = CGRectMake(0, 0, width, height);
    
    // 1. Display Tutorial.
    UIView *tutorial = [self displayTutorial:swipeableView frame:frame];
    if (tutorial){
        return tutorial;
    }
    [self emptyView];
    
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
                                                   key: @"swipeRightTutorial"
                                              delegate:self];
    }
    if ([defaults boolForKey:@"swipeLeftTutorial"] == NO) {
        return [[TutorialCardView alloc] initWithFrame: frame
                                                   key: @"swipeLeftTutorial"
                                              delegate:self];
    }
    return nil;
}

#pragma mark - ChooseBeaconToDisplay
-(UIView *) beaconCardViewToDisplay:(ZLSwipeableView *)swipeableView frame:(CGRect)frame{
    Card * cardToShow = [self.cardDeck cardToShowOnScreen];
    if (cardToShow == nil) {
        [self updateNumberOfBeacons];
        [self.swipeableView loadViewsIfNeeded];
    }
    else{
        [cardToShow show];
        BeaconCardView * cardView = [[BeaconCardView alloc] initWithFrame: frame
                                                                   beacon: cardToShow
                                                                 delegate:self];
        return cardView;
    }
    return nil;
}

#pragma mark - helpers
-(void) updateNumberOfBeacons{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"swipeRightTutorial"] == NO || [defaults boolForKey:@"swipeLeftTutorial"] == NO) {
        self.swipeableView.numberOfActiveViews = 1;
        [self.swipeableView loadViewsIfNeeded];
        return;
    }
    NSUInteger numberOfBeacons = [[self.cardDeck cardsInRange] count];
    if (numberOfBeacons >= 3) {
        self.swipeableView.numberOfActiveViews = 3;
        [self.swipeableView loadViewsIfNeeded];
        return;
    }
    self.swipeableView.numberOfActiveViews = numberOfBeacons;
    [self.swipeableView loadViewsIfNeeded];
}

-(void) updateNavBar{
    [self.swipeableView loadViewsIfNeeded];
    CardView * top = (CardView *)[self.swipeableView topView];
    if (top == nil) {
        [self emptyView];

    }
    else{
        self.titleLabel.title = top.cardPrompt;
        self.titleLabel.prompt = top.cardTitle;
        [self hidePulse];
    }
    
}

-(void) hidePulse{
    self.pulseView.hidden = YES;
    self.backgroundPulseView.hidden = YES;
}

-(void) showPulse{
    self.pulseView.hidden = NO;
    self.backgroundPulseView.hidden = NO;
}

-(void)emptyView{
    self.titleLabel.title = @"Searching...";
    self.titleLabel.prompt = @"Walk Around your town";
    [self showPulse];
}

#pragma mark - Init Methods
-(void) initSwipeableView{
    CGFloat height = self.view.frame.size.height * SWIPEABLE_RATIO;
    CGFloat width  = self.view.frame.size.width;
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    //self.swipeableView.backgroundColor = [UIColor colorWithRed:0 green:0.082 blue:0.141 alpha:1];
    self.swipeableView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    self.swipeableView.dataSource       = self;
    self.swipeableView.delegate         = self;
    [self.view addSubview:self.swipeableView];
}

-(void) initPulse{
    self.pulseView = [[UIView alloc] initWithFrame:CGRectMake(self.swipeableView.frame.size.width/2 - 50,
                                                              self.swipeableView.frame.size.height/2 - 50,
                                                              100, 100)];
    self.pulseView.backgroundColor = [UIColor colorWithRed:0.125 green:0.722 blue:0.902 alpha:1];
    self.pulseView.layer.cornerRadius = 50;
    self.backgroundPulseView = [[UIImageView alloc] initWithFrame:CGRectMake(self.swipeableView.frame.size.width/2 - 50,
                                                                             self.swipeableView.frame.size.height/2 - 50,
                                                                             100, 100)];
    self.backgroundPulseView.image = [UIImage imageNamed:@"pulseBackground.png"];
    
    [self.swipeableView addSubview:self.pulseView];
    [self.swipeableView addSubview:self.backgroundPulseView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    animation.removedOnCompletion = false;
    animation.fromValue = [NSNumber numberWithFloat:1.4];
    animation.toValue = [NSNumber numberWithFloat:2];
    
    [self.pulseView.layer addAnimation:animation forKey:@"scale"];
}



#pragma mark - Card Swipes
-(void) skipCard:(BeaconCardView *) view {
}

#pragma mark - Background Location Manager
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    //TODO
}

#pragma mark - AYCardViewDelegate Protocol
-(void)topCardViewUpdate{
    [self updateNavBar];
}

#pragma mark - Notifications
-(void) enterRegion{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Chimp Chimp!";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

@end
