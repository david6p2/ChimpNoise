//
//  ScanViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 3/22/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()
@property (weak, nonatomic) IBOutlet UIView *deckView;

@end

@implementation ScanViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Start Ranging and Monitoring Regions
    self.nearBeaconsScanner = [NearBeaconsScanner new];
    self.regionsScanner     = [[RegionsScanner alloc] initWithDelegate:self.nearBeaconsScanner];
    [self.regionsScanner scan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSwipeableView];
    [self initPulse];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateView)
                                                 name:@"nearBeaconsScannerEvent"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.regionsScanner stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [self.swipeableView loadViewsIfNeeded];
}

-(void) initSwipeableView{
    self.swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.view.frame];
    self.swipeableView.allowedDirection = ZLSwipeableViewDirectionHorizontal;
    self.swipeableView.backgroundColor = [UIColor colorWithRed:0 green:0.082 blue:0.141 alpha:1];
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    self.swipeableView.numberOfActiveViews = 0;
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

-(void) hidePulse{
    self.pulseView.hidden = YES;
    self.backgroundPulseView.hidden = YES;
}

-(void) showPulse{
    self.pulseView.hidden = NO;
    self.backgroundPulseView.hidden = NO;
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction
{
    NSLog(@"ScanViewController.didSwipeView");
    BeaconCardView *beaconCardView = (BeaconCardView *)view;
    [beaconCardView.beacon hide];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation
{
    if (10 <= translation.x) {
        // Show Next Label
        //TODO
    }
    else if (translation.x <= -10){
        // Show Delete Label
        //TODO
    }
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    NSLog(@"nextViewForSwipeableView");
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect frame = CGRectMake(0, 0, swipeableView.frame.size.width - 50, swipeableView.frame.size.height - 150);
    CGPathRef path = CGPathCreateWithRect(frame, NULL);
    maskLayer.path = path;
    CGPathRelease(path);
    
    // 2. If no tutorial to display then display beacon.
    UIView *beaconCardView = [self beaconCardViewToDisplay:swipeableView frame:frame];
    if (beaconCardView) {
        beaconCardView.layer.mask = maskLayer;
        return beaconCardView;
    }
    
    // 3. If no beacon to display then return nil.
    return nil;
}

#pragma mark - ChooseBeaconToDisplay
-(UIView *) beaconCardViewToDisplay:(ZLSwipeableView *)swipeableView frame:(CGRect)frame{
    AYBeacon * beaconToShow = [self.nearBeaconsScanner next];
    if (beaconToShow != nil) {
        return [[BeaconCardView alloc] initWithFrame: frame
                                              beacon: beaconToShow
                                            delegate:self];
    }
    return nil;
}


#pragma mark - Observe Changes in NearBeaconsScanner
-(void) updateView{
    NSUInteger nearBeaconsNumber = [self.nearBeaconsScanner.nearBeacons count];
    
    NSLog(@"nearBeaconsScanner.nearBeacons.count: %lu", nearBeaconsNumber);
    NSLog(@"nearBeaconsScanner.nearBeacons: %@", self.nearBeaconsScanner.nearBeacons);
    
    self.swipeableView.numberOfActiveViews = nearBeaconsNumber;
    [self.swipeableView loadViewsIfNeeded];
    
    if(nearBeaconsNumber == 0){
        [self showPulse];
    }
    else{
        [self hidePulse];
    }
}

#pragma mark - AYCardViewDelegate Protocol
-(void)topCardViewUpdate{
}

@end
