//
//  TextCardViewViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 5/9/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface TextCardViewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Card *card;
@end
