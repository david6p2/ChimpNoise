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
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.imageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    NSLog(@"%@", self.card.imageURL);
    [self.view setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImageUrl:(NSString *)url{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}
@end
