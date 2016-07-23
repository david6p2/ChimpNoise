//
//  CardPageViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/27/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "CardPageViewController.h"

@implementation CardPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.subjectLabel.text = self.subjectText;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowColor = [UIColor grayColor].CGColor;
    self.view.layer.shadowOpacity = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
