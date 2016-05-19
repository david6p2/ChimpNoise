//
//  FavoritesViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 5/17/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *favoriteCards;
@property NSInteger index;
@end
