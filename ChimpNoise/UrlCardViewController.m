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
    
    //init Favorite Deck
    self.favoritesDeck = [FavoritesDeck sharedInstance];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.view setClipsToBounds:YES];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.urlImage]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.imageView setClipsToBounds:YES];
    self.titleLabel.text = self.card.beaconName;
    self.urlTitle.text = self.card.urlTitle;
    self.urlDescription.text = self.card.urlDescription;
    [self.urlDescription setNumberOfLines:0];
    [self.urlDescription sizeToFit];
    
    self.urlView.layer.cornerRadius = 15.0;
    self.urlView.layer.borderWidth = 0.5;
    self.urlView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.urlView setClipsToBounds:YES];
    
    //Init Long Press Gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.allowableMovement = 100.0f;
    [self.view addGestureRecognizer:longPress];
    
    //Init Favorite Heart Image View
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.favoriteHeartImageView setUserInteractionEnabled:YES];
    [self.favoriteHeartImageView addGestureRecognizer:singleTap];
    if ([self.favoritesDeck contains:self.card]) {
        self.favoriteHeartImageView.image =[UIImage imageNamed: @"favorite_heart_remove.png"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.card.url]];
}

#pragma mark - Long Press Gesture
-(void)longPressDetected:(UILongPressGestureRecognizer *)longPress
{
    [self showOptionsMenu];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)tapDetected{
    [self showOptionsMenu];
}

-(void) showOptionsMenu{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:self.card.businessName
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([self.favoritesDeck contains:self.card]) {
        UIAlertAction* removeFromFavorites = [UIAlertAction actionWithTitle:@"Remove from My Decks"
                                                                      style:UIAlertActionStyleDestructive
                                                                    handler:^(UIAlertAction * action) {
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeCardToFavorites" object:self.card];
                                                                        self.favoriteHeartImageView.image =[UIImage imageNamed: @"favorite_heart_add.png"];
                                                                    }];
        [alert addAction:removeFromFavorites];
    }
    else{
        UIAlertAction* addToFavorites = [UIAlertAction actionWithTitle:@"Add to My Decks"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"addCardToFavorites" object:self.card];
                                                                   self.favoriteHeartImageView.image =[UIImage imageNamed: @"favorite_heart_remove.png"];
                                                               }];
        [alert addAction:addToFavorites];
    }
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
