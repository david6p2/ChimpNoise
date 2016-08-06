//
//  ImageCardViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPageViewController.h"
#import "FavoritesDeck.h"
#import "Card.h"
#import "Authentication.h"

@interface ImageCardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteHeartImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *tempUIView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Card *card;
@property (strong, nonatomic) FavoritesDeck *favoritesDeck;
@property (strong, nonatomic) Authentication *auth;
@end
