//
//  TutorialCardView.h
//  ChimpNoise
//
//  Created by Andres Yepes on 12/4/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialCardView : UIView

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSString *key;

- (instancetype)initWithFrame:(CGRect)frame key:(NSString *) key imageURL: (NSString *) imageURL;
- (instancetype)initWithCoder:(NSCoder *)aDecoder key:(NSString *) key imageURL: (NSString *) imageURL;

@end
