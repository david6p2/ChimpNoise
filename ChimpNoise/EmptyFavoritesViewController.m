//
//  EmptyFavoritesViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 5/19/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "EmptyFavoritesViewController.h"

@interface EmptyFavoritesViewController ()

@end

@implementation EmptyFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
