//
//  UrlCardViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "UrlCardViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UrlCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view setClipsToBounds:YES];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.urlImage]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.imageView setClipsToBounds:YES];
    self.titleLabel.text = self.card.businessName;
    self.urlTitle.text = self.card.urlTitle;
    self.urlDescription.text = self.card.urlDescription;
    [self.urlDescription setNumberOfLines:0];
    [self.urlDescription sizeToFit];
    
    self.urlView.layer.cornerRadius = 15.0;
    self.urlView.layer.borderWidth = 0.5;
    self.urlView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.urlView setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.card.url]];
}
@end
