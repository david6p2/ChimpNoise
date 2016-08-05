//
//  Authentication.m
//  ChimpNoise
//
//  Created by Andres Yepes on 8/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//

#import "Authentication.h"

@implementation Authentication

-(instancetype)init{
    if (self = [super init]) {
        self.manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

-(BOOL) signUpWithEmail:(NSString *)email password:(NSString *)pass{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", SERVER_URL, SIGN_UP_URI];
    NSDictionary *params = @{@"first_name": @"udpate",
                             @"last_name": @"update",
                             @"email": email,
                             @"password": pass,
                             @"phone": @"123"};
    [self.manager POST:url
            parameters:params
               success:^(AFHTTPRequestOperation *operation, id responseObject){
                   NSDictionary *response = responseObject;
                   NSLog(@"%@", response);
                   if([response[@"error"] integerValue] == 1){
                        NSLog(@"%@", response[@"formErrors"]);
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpStatus"
                                                                           object:nil
                                                                        userInfo:@{@"status" : @AUTHENTICATION_FAILED}];
                   }
                   if([response[@"error"] integerValue] == 0){
                       NSString *token = response[@"token"];
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:token forKey:@"user_auth_token"];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpStatus"
                                                                           object:nil
                                                                         userInfo:@{@"status" : @AUTHENTICATION_SUCCESS}];
                   }
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error){
                   NSLog(@"error %@", error);
               }];
    return YES;
}
@end
