//
//  SignInViewController.m
//  ChimpNoise
//
//  Created by Andres Yepes on 8/5/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.auth = [[Authentication alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signInStatus:)
                                                 name:@"signInStatus"
                                               object:nil];
    [self.emailTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *pass = self.passwordTextField.text;
    if([self validateFieldsEmail:email password:pass]){
        [self.auth signInWithEmail:email password:pass];
    }
}

//Private
-(BOOL)validateFieldsEmail:(NSString *)email password:(NSString *) pass{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign in"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    if([email isEqualToString:@""] || [pass isEqualToString:@""]){
        alert.message = @"please fill in all fields";
        [alert show];
        return NO;
    }
    if(![self.auth NSStringIsValidEmail:email]){
        alert.message = @"Please enter a valid email";
        [alert show];
        return NO;
    }
    return YES;
}

//Notification
-(void) signInStatus:(NSNotification *)notification{
    NSNumber *status = [[notification userInfo] objectForKey:@"status"];
    if([status integerValue] == AUTHENTICATION_FAILED){
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign in"
                                                        message:@"Invalid Credentials"
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

//Keyboard
-(IBAction)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

@end
