//
//  CardViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 11/2/15.
//  Copyright © 2015 Andres Yepes. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardTitleLabel.text = @"probando";
    NSLog(@"CardViewController: viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
