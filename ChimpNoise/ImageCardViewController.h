//
//  ImageCardViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/28/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPageViewController.h"
#import "Card.h"

@interface ImageCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Card *card;
-(void)setImageUrl:(NSString *)url;
@end
