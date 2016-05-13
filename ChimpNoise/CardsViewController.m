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
    [self emptyPageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init CardViewController
    self.pageViewController = nil;
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    self.pageViewController.view.frame = frame;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //Init Notifcations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterRegion)
                                                 name:@"enterRegion"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exitRegion:)
                                                 name:@"exitRegion"
                                               object:nil];
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 4
                                                  target: self
                                                selector:@selector(refreshPageView)
                                                userInfo: nil repeats:YES];
    
    //Init BeaconListener
    self.beaconListener = [BeaconListener sharedInstance];
    [self.beaconListener requestAlwaysAuthorization];
    [self.beaconListener startMonitoring];
    [self.beaconListener startRanging];
    
    // Init Card Deck
    self.cardDeck = [CardDeck sharedInstance];
    self.index = 0;
    
    //Init Long Press Gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.allowableMovement = 100.0f;
    [self.view addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Page Refresh
-(void) refreshPageView{
    NSLog(@"cardDeck.cardsInRange.count: %li", [[self.cardDeck cardsInRange] count]);
    if ([[self.pageViewController viewControllers] count] != 0) {
        self.index = ((CardPageViewController *)[self.pageViewController viewControllers][0]).index;
        NSLog(@"cardOnTopIndex: %li", self.index);
    }
    
    if ([[self.cardDeck cardsInRange] count] == 0) {
        [self emptyPageView];
        return;
    }
    
    [self nonEmptyPageView];
    return;
}

-(void) emptyPageView{
    NSMutableArray *cards = [NSMutableArray new];
    EmptyCardViewController *emptyInitialView = [self.storyboard instantiateViewControllerWithIdentifier:@"emptyCardViewController"];
    emptyInitialView.index = 0;
    [cards addObject:emptyInitialView];
    [self.pageViewController setViewControllers:cards
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

-(void)nonEmptyPageView{
    NSMutableArray *cards = [NSMutableArray new];
    [cards addObject:[self cardOnIndex:self.index]];
    [self.pageViewController setViewControllers:cards
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}

#pragma mark - Notifications
-(void) enterRegion{
    //TODO
}

-(void) exitRegion:(NSNotification *)notification{
    self.index = 0;
}


#pragma mark - UIPageViewControllerDataSource

//-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
//    NSLog(@"CardsViewController.presentacionCount");
//    return [[self.cardDeck cardsInRange] count];
//}
//
//-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
//    NSLog(@"CardsViewController.presentacionIndex");
//    return self.index;
//}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController{
    NSLog(@"before");
    NSUInteger index = ((CardPageViewController *)viewController).index;
    if (index == 0) {
        return nil;
    }
    index--;
    return [self cardOnIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController{
    NSLog(@"after");
    NSUInteger index = ((CardPageViewController *)viewController).index;
    index++;
    if (index == [[self.cardDeck cardsInRange] count]) {
        return nil;
    }
    return [self cardOnIndex:index];
}

#pragma mark - CardOnIndex
-(UIViewController *) cardOnIndex:(NSInteger) index{
    Card *card = [self.cardDeck cardsInRange][index];
    if ([card.type isEqualToString:@"image"]) {
        ImageCardViewController *imageCard = [self.storyboard instantiateViewControllerWithIdentifier:@"imageCardViewController"];
        imageCard.card = card;
        imageCard.index = index;
        [imageCard viewDidLoad];
        return imageCard;
    }
    if ([card.type isEqualToString:@"url"]) {
        ImageCardViewController *urlCard = [self.storyboard instantiateViewControllerWithIdentifier:@"urlCardViewController"];
        urlCard.card = card;
        urlCard.index = index;
        [urlCard viewDidLoad];
        return urlCard;
    }
    if ([card.type isEqualToString:@"text"]) {
        ImageCardViewController *urlCard = [self.storyboard instantiateViewControllerWithIdentifier:@"textCardViewViewController"];
        urlCard.card = card;
        urlCard.index = index;
        [urlCard viewDidLoad];
        return urlCard;
    }

    return nil;
}

#pragma mark - Long Press Gesture
-(void)longPressDetected:(UILongPressGestureRecognizer *)longPress
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* addToFavorites = [UIAlertAction actionWithTitle:@"Add to favorites"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:addToFavorites];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
