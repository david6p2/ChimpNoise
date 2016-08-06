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
        self.defaults = [NSUserDefaults standardUserDefaults];
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
                       [self.defaults setObject:token forKey:USER_AUTH_TOKEN];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpStatus"
                                                                           object:nil
                                                                         userInfo:@{@"status" : @AUTHENTICATION_SUCCESS}];
                   }
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error){
                   NSLog(@"error %@", error);
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpStatus"
                                                                       object:nil
                                                                     userInfo:@{@"status" : @AUTHENTICATION_FAILED}];
               }];
    return YES;
}

-(BOOL)signInWithEmail:(NSString *)email password:(NSString *)pass{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@", SERVER_URL, SIGN_IN_URI];
    NSDictionary *params = @{@"user": email,
                             @"password": pass};
    [self.manager POST:url
            parameters:params
               success:^(AFHTTPRequestOperation *operation, id responseObject){
                   NSDictionary *response = responseObject;
                   NSLog(@"%@", response);
                   if([response[@"error"] integerValue] == 1){
                       NSLog(@"%@", response[@"formErrors"]);
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"signInStatus"
                                                                           object:nil
                                                                         userInfo:@{@"status" : @AUTHENTICATION_FAILED}];
                   }
                   if([response[@"error"] integerValue] == 0){
                       NSString *token = response[@"token"];
                       [self.defaults setObject:token forKey:USER_AUTH_TOKEN];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"signInStatus"
                                                                           object:nil
                                                                         userInfo:@{@"status" : @AUTHENTICATION_SUCCESS}];
                   }
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error){
                   NSLog(@"error:%@", error);
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"signInStatus"
                                                                       object:nil
                                                                     userInfo:@{@"status" : @AUTHENTICATION_FAILED}];
               }];
    return YES;
}

-(BOOL)addFavorite:(NSString *)cardId{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@%@", SERVER_URL, ADD_FAVORITE_URI, cardId];
    NSLog(@"url: %@", url);
    NSDictionary *params = @{@"act": [self userAuthToken]};
    NSLog(@"params: %@", params);
    [self.manager POST:url
            parameters:params
               success:^(AFHTTPRequestOperation *operation, id responseObject){
                   NSLog(@"add favorite success");
               }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                   NSLog(@"add favorite failure: %@", error);
               }];
    return YES;
}


-(BOOL)isLoggedIn{
    NSString *token =[self.defaults objectForKey:USER_AUTH_TOKEN];
    if(token == nil || [token isEqualToString:@""]){
        return NO;
    }
    return YES;
}

-(NSString *)userAuthToken{
    return [self.defaults objectForKey:USER_AUTH_TOKEN];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end
