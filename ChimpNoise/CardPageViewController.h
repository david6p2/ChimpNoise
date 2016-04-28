//
//  CardPageViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 4/27/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardPageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) NSString *subjectText;
@property (nonatomic, assign) NSInteger index;
@end
