//
//  ImageCardViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "ImageCardViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ImageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.imageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.view setClipsToBounds:YES];
    [self.imageView setClipsToBounds:YES];
    
    self.titleLabel.text = self.card.businessName;
    
    self.imageView.layer.cornerRadius = 15.0;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
