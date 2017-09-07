//
//  HsinYI.h
//  OAuth
//
//  Created by giming on 2014/3/17.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import <Foundation/Foundation.h>


// OAuth Stuff
extern NSString * const oauthTokenKey;
extern NSString * const oauthTokenKeySecret;
extern NSString * const requestToken;
extern NSString * const requestTokenSecret;
extern NSString * const accessToken;
extern NSString * const accessTokenSecret;
//extern NSString * const dropboxUIDKey;
//extern NSString * const dropboxTokenReceivedNotification;

// App settings
extern NSString * const appFolder;

typedef void (^HsinYiRequestTokenCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface HsinYI : NSObject


// oauth
// step 1 取得 requestToken
+ (void)requestTokenWithCompletionHandler:(HsinYiRequestTokenCompletionHandler)completionBlock;
// step 2 以step1 的 requestToken 取得 accessToken
+ (void)exchangeTokenForUserAccessTokenURLWithCompletionHandler:(HsinYiRequestTokenCompletionHandler)completionBlock;


// helpers

// 將回傳值 response 轉成 NSDictionary
+ (NSDictionary*)dictionaryFromOAuthResponseString:(NSString*)response;
// 將 Header 轉成 NSDictionary
+ (NSDictionary *)dictionaryForOAuthRequestHeaderString:(NSString *)request;
@end
