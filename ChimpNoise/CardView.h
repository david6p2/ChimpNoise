//
//  CardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 11/1/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYBeacon.h"

@interface CardView : UIView

@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
- (instancetype)initWithFrame:(CGRect)frame beacon:(AYBeacon *) beacon;
- (instancetype)initWithCoder:(NSCoder *)aDecoder beacon:(AYBeacon *) beacon;
@end
