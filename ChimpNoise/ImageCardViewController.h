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

@interface ImageCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteHeartImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Card *card;

@property (strong, nonatomic) FavoritesDeck *favoritesDeck;
@end
