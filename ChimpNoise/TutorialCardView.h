//
//  TutorialCardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 12/4/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface TutorialCardView : CardView

@property (strong, nonatomic) NSString *key;

- (instancetype)initWithFrame:(CGRect)frame key:(NSString *) key delegate:(id) delegate;
- (instancetype)initWithCoder:(NSCoder *)aDecoder key:(NSString *) key delegate:(id) delegate;

@end
