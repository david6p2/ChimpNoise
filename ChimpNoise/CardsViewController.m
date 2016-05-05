//
//  CardsViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/27/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "CardsViewController.h"

@interface CardsViewController ()

@end

@implementation CardsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Init BeaconListener
    self.beaconListener = [BeaconListener sharedInstance];
    [self.beaconListener requestAlwaysAuthorization];
    [self.beaconListener startMonitoring];
    [self.beaconListener startRanging];
    // Init Card Deck
    self.cardDeck = [CardDeck sharedInstance];
    self.guarda = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2
                                                  target: self
                                                selector:@selector(refreshPageView)
                                                userInfo: nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterRegion)
                                                 name:@"enterRegion"
                                               object:nil];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    self.pageViewController.view.frame = frame;
    self.pageViewController.dataSource = self;
    [self refreshPageView];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notifications
-(void) refreshPageView{
    NSLog(@"cardDeck.cardsInRange.count: %li", [[self.cardDeck cardsInRange] count]);
    NSMutableArray *cards = [NSMutableArray new];
    if ([[self.cardDeck cardsInRange] count] == 0 || self.guarda == YES) {
        EmptyCardViewController *emptyInitialView = [self.storyboard instantiateViewControllerWithIdentifier:@"emptyCardViewController"];
        [cards addObject:emptyInitialView];
        self.guarda = NO;
    }
    else{
        [cards addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"imageCardViewController"]];
        self.guarda = YES;
    }
    [self.pageViewController setViewControllers:cards
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

-(void) enterRegion{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Noise!";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - UIPageViewControllerDataSource
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    NSLog(@"CardsViewController.presentacionCount");
    return [[self.cardDeck cardsInRange] count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    NSLog(@"CardsViewController.presentacionIndex");
    return 0;
}

@end
