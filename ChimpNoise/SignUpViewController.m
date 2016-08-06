//
//  SignUpViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 8/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.auth = [[Authentication alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signUpStatus:)
                                                 name:@"signUpStatus"
                                               object:nil];
    
    NSLog(@"logged in: %s", [self.auth isLoggedIn] ? "true" : "false");
    NSLog(@"logged in: %@", [self.auth userAuthToken]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *pass = self.passwordTextField.text;
    NSString *confirmPass = self.confirmPasswordTextField.text;
    if([self validateFieldsEmail:email password:pass confirm:confirmPass]){
        [self.auth signUpWithEmail:email password:pass];
    }
}

//Private
-(BOOL)validateFieldsEmail:(NSString *)email password:(NSString *) pass confirm:(NSString *) confirmPass {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign up"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    if([email isEqualToString:@""] || [pass isEqualToString:@""] || [confirmPass isEqualToString:@""]){
        alert.message = @"please fill in all fields";
        [alert show];
        return NO;
    }
    if(![self.auth NSStringIsValidEmail:email]){
        alert.message = @"Please enter a valid email";
        [alert show];
        return NO;
    }
    if (![pass isEqualToString:confirmPass]) {
        alert.message = @"Please confirm your password";
        [alert show];
        return NO;
    }
    return YES;
}

//Notifications
-(void) signUpStatus:(NSNotification *)notification{
    NSNumber *status = [[notification userInfo] objectForKey:@"status"];
    if([status integerValue] == AUTHENTICATION_FAILED){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign up"
                                                        message:@"Please enter valid information."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if([status integerValue] == AUTHENTICATION_SUCCESS){
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarViewController"];
        [self presentModalViewController:viewController animated:YES];
    }
    
}

//keyboard
-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}


@end
