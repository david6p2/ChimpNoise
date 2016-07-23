//
//  ImageCardViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "ImageCardViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

bool a = NO;

@implementation ImageCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init Favorite Deck
    self.favoritesDeck = [FavoritesDeck sharedInstance];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.card.imageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.view setClipsToBounds:YES];
    [self.imageView setFrame:self.containerView.frame];
    NSLog(@"width: %f - Height: %f", self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView setClipsToBounds:YES];
    
    self.titleLabel.text = self.card.beaconName;
    
    //init Border
    self.containerView.layer.cornerRadius = 15.0;
    self.containerView.layer.borderWidth = 0.5;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;

    
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
    
    if (self.card.showBackCard) {
        [self.imageView setHidden:YES];
        [self.backView setHidden:NO];
    }
    else{
        [self.imageView setHidden:NO];
        [self.backView setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIAlertAction* flipAction = [UIAlertAction actionWithTitle:@"Flip Card"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self flip:self];
                                                          }];
    
    
    [alert addAction:flipAction];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Flip
- (IBAction)flip:(id)sender
{
    NSLog(@"flip!");
    if (self.card.showBackCard == NO) {
        [UIView transitionFromView:self.imageView toView:self.backView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        [self.backView setHidden:NO];
        [self.imageView setHidden:YES];
        self.card.showBackCard = YES;
    }
    else {
        [UIView transitionFromView:self.backView toView:self.imageView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:NULL];
        [self.imageView setHidden:NO];
        [self.backView setHidden:YES];
        self.card.showBackCard = NO;
    }
}

@end
