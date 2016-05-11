//
//  UrlCardViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface UrlCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *urlView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *urlTitle;
@property (weak, nonatomic) IBOutlet UILabel *urlDescription;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Card *card;
@end
