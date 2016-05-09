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
    [self.view setClipsToBounds:YES];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.urlImage]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.imageView setClipsToBounds:YES];
    self.titleLabel.text = self.card.businessName;
    self.urlTitle.text = self.card.urlTitle;
    self.urlDescription.text = self.card.urlDescription;
    [self.urlDescription setNumberOfLines:0];
    [self.urlDescription sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.card.url]];
}

@end
