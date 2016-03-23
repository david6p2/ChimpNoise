//
//  ScanViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 3/22/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSwipeableView.h"

@interface ScanViewController : UIViewController
@property (strong, nonatomic) UIView *pulseView;
@property (strong, nonatomic) UIImageView *backgroundPulseView;
@property (nonatomic, strong) ZLSwipeableView *swipeableView;
@end
