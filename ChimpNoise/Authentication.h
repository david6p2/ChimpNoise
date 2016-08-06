//
//  Authentication.h
//  ChimpNoise
//
//  Created by Andres Yepes on 8/4/16.
//  Copyright © 2016 Andres Yepes. All rights reserved.
//
//CREATE ACCOUNT: POST /api/client
//params: first_name, last_name, email, password, phone
//
//LOGIN: POST /api/client/login
//params: user, password
//
//GET FAVORITE LIST: GET /api/client/card/favorite/list?act=TOKEN (edited)
//
//ADD FAVORITE: POST /api/client/card/favorite/:id?act=TOKEN (edited)
//nota: (:id) = id card
//
//REMOVE FAVORITE: DELETE /api/client/card/favorite/:id?act=TOKEN



#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>

#define SERVER_URL @"http://www.chimpnoise.com/api/client"
#define SIGN_UP_URI @""
#define SIGN_IN_URI @"/login"
#define FAVORITES_URI @"/card/favorite/list"
#define ADD_FAVORITE_URI @"/card/favorite/"
#define REMOVE_FAVORITE_URI @"/card/favorite/"

#define AUTHENTICATION_SUCCESS 0
#define AUTHENTICATION_FAILED 1

#define USER_AUTH_TOKEN @"user_auth_token"


@interface Authentication : NSObject
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSUserDefaults *defaults;

-(BOOL) signUpWithEmail:(NSString *)email password:(NSString *)pass;
-(BOOL) signInWithEmail:(NSString *)email password:(NSString *)pass;
-(BOOL) isLoggedIn;
-(NSString *)userAuthToken;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(BOOL) addFavorite:(NSString *)cardId;
@end
