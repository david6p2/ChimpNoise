//
//  CardsViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/27/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPageViewController.h"
#import "ImageCardViewController.h"
#import "UrlCardViewController.h"
#import "EmptyCardViewController.h"
#import "BeaconListener.h"
#import "CardDeck.h"
#import "Card.h"

@interface CardsViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *subjectsArray;
@property (nonatomic, strong) BeaconListener* beaconListener;
@property (nonatomic, strong) CardDeck* cardDeck;
@property BOOL guarda;

@end
