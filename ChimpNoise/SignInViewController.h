//
//  SignInViewController.h
//  ChimpNoise
//
//  Created by Andres Yepes on 8/5/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authentication.h"

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) Authentication *auth;
@end
