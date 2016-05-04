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
    
    self.subjectsArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterRegion)
                                                 name:@"enterRegion"
                                               object:nil];

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    self.pageViewController.dataSource = self;
    CardPageViewController *card = [self viewControllerAtIndex:0];
    NSArray *cardsArray = @[card];
    [self.pageViewController setViewControllers:cardsArray
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPageViewControllerDataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController{
    NSLog(@"before");
    NSUInteger index = ((CardPageViewController *)viewController).index;
    if (index == 0) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController{
    NSLog(@"after");
    NSUInteger index = ((CardPageViewController *)viewController).index;
    index++;
    if (index == [self.subjectsArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.subjectsArray count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.subjectsArray count] == 0) || (index >= [self.subjectsArray count])) {
        return nil;
    }
    if(index % 2 == 0){
        UrlCardViewController *card = [self.storyboard instantiateViewControllerWithIdentifier:@"urlCardViewController"];
        card.index = index;
        return card;
    }
    else{
        ImageCardViewController *imageCard = [self.storyboard instantiateViewControllerWithIdentifier:@"imageCardViewController"];
        imageCard.index = index;
        return imageCard;
    }

}

@end
