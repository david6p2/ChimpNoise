//
//  EmptyCardViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 5/5/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyCardViewController : UIViewController

@property (strong, nonatomic) UIView *pulseView;
@property (strong, nonatomic) UIImageView *backgroundPulseView;
@property (nonatomic, assign) NSInteger index;
@end
