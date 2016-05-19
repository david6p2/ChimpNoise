//
//  FavoritesViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 5/17/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "FavoritesViewController.h"
#import "CardPageViewController.h"
#import "ImageCardViewController.h"
#import "textCardViewViewController.h"
#import "UrlCardViewController.h"
#import "EmptyCardViewController.h"
#import "Card.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Init CardViewController
    self.pageViewController = nil;
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0.129 blue:0.278 alpha:1];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    self.pageViewController.view.frame = frame;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTabBarBadge)
                                                 name:@"favoritesNotification"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favorites = [defaults arrayForKey:@"favorites"];
    [self initFavoriteCards:(NSArray *)favorites];
    NSLog(@"favorites %@", self.favoriteCards);
    [self refreshPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//private
-(void) initFavoriteCards:(NSArray *)favorites{
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *cardDictionary in favorites) {
        [array addObject:[[Card alloc] initWithBusinessName:cardDictionary[@"business_name"]
                                                     beacon:nil
                                             serverResponse:cardDictionary]];
    }
    self.favoriteCards = array;
}

#pragma mark - UIPageViewControllerDataSource
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
    if (index >= [self.favoriteCards count]) {
        return nil;
    }
    return [self cardOnIndex:index];
}

#pragma mark - CardOnIndex
-(UIViewController *) cardOnIndex:(NSInteger) index{
    Card *card = self.favoriteCards[index];
    if (index < 0 || [self.favoriteCards count] <= index) {
        return nil;
    }
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

#pragma mark - Page Refresh
-(void) refreshPageView{
    NSLog(@"cardDeck.cardsInRange.count: %li", [self.favoriteCards count]);
    if ([[self.pageViewController viewControllers] count] != 0) {
        self.index = ((CardPageViewController *)[self.pageViewController viewControllers][0]).index;
        NSLog(@"cardOnTopIndex: %li", self.index);
    }
    
    if ([self.favoriteCards count] == 0) {
        [self emptyPageView];
        return;
    }
    [self nonEmptyPageView];
    return;
}

-(void) emptyPageView{
    NSMutableArray *cards = [NSMutableArray new];
    EmptyCardViewController *emptyInitialView = [self.storyboard instantiateViewControllerWithIdentifier:@"emptyFavoritesViewController"];
    emptyInitialView.index = 0;
    [cards addObject:emptyInitialView];
    [self.pageViewController setViewControllers:cards
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.tabBarItem.badgeValue = nil;
}

-(void)nonEmptyPageView{
    //ensure self.index is in range
    if (self.index < 0) {
        self.index = 0;
    }
    if ([self.favoriteCards count] <= self.index) {
        self.index = [self.favoriteCards count] - 1;
    }
    
    NSMutableArray *cards = [NSMutableArray new];
    [cards addObject:[self cardOnIndex:self.index]];
    [self.pageViewController setViewControllers:cards
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[self.favoriteCards count]];
}

#pragma mark - Favorites Change Notification
-(void)updateTabBarBadge{
    [self viewDidAppear:NO];
}


@end
