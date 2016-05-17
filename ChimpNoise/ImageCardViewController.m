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
    
    //Init Long Press Gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.allowableMovement = 100.0f;
    [self.view addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Long Press Gesture
-(void)longPressDetected:(UILongPressGestureRecognizer *)longPress
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:self.card.businessName
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.card.isFavorite == NO) {
        UIAlertAction* addToFavorites = [UIAlertAction actionWithTitle:@"Add to favorites"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   [self.card saveToFavorites];
                                                               }];
        [alert addAction:addToFavorites];
    }
    if (self.card.isFavorite == YES) {
        UIAlertAction* removeFromFavorites = [UIAlertAction actionWithTitle:@"Remove from favorites"
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction * action) {
                                                                   [self.card removeFromFavorites];
                                                               }];
        [alert addAction:removeFromFavorites];
    }
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
