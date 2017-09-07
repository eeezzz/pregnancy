//
//  HsinYI.m
//  OAuth
//
//  Created by giming on 2014/3/17.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "HsinYI.h"


//#warning INSERT YOUR OWN API KEY and SECRET HERE
static NSString *apiKey = @"d8dab14b06e942658fbc4877de07de30";
static NSString *appSecret = @"167e1bba413a4e44b445b52a9182c606";

NSString * const oauthTokenKey = @"oauth_token";
NSString * const oauthTokenKeySecret = @"oauth_token_secret";

#pragma mark - saved in NSUserDefaults
NSString * const requestToken = @"request_token";
NSString * const requestTokenSecret = @"request_token_secret";

NSString * const accessToken = @"access_token";
NSString * const accessTokenSecret = @"access_token_secret";

@implementation HsinYI


+ (void)requestTokenWithCompletionHandler:(HsinYiRequestTokenCompletionHandler)completionBlock
{
    /* 
       設定 NSURLSessionConfiguration
       取得 header 字串, 轉換成 NSDictionary 後，加入 NSURLSessionConfiguration
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 取得 header 字串
    NSString *authorizationHeader = [self plainTextAuthorizationHeaderForAppKey:apiKey
                                                                    appSecret:appSecret
                                                                          token:nil
                                                                    tokenSecret:nil];
    
    NSLog(@"header : %@",authorizationHeader);
    // 轉換成 NSDictionary, 因為 sessionConfig setHttpAdditionalHeaders 的參數是一個 NSDictionary
    NSDictionary* header = [self dictionaryForOAuthRequestHeaderString:authorizationHeader];
    // 加入 NSURLSessionConfiguration
    [sessionConfig setHTTPAdditionalHeaders:header];
    
    /*
        設定NSURLSession
        設定生成 NSMutableURLRequest 所需的 NSURL
        設定生成 NSURLSessionDataTask 所需的 NSMutableURLRequest
        生成 NSURLSessionDataTask 並啟動    
     */
    
    // 設定生成 NSMutableURLRequest 所需的 NSURL
    NSString* urlString = [NSString stringWithFormat:@"http://api.kimy.com.tw/Auth/OAuth/RequestToken"];
    NSURL* requestTokenURL = [NSURL URLWithString:urlString];
    

    

    // 手動測試用
//    NSMutableDictionary * header = [[NSMutableDictionary alloc]init];
//    [header setObject:client_key forKey:@"client_key"];
//    [header setObject:client_secret forKey:@"client_secret"];
    
   
    // 設定生成 NSURLSessionDataTask 所需的 NSMutableURLRequest
    //NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.kimy.com.tw/Auth/OAuth/RequestToken" ]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestTokenURL];
    [request setHTTPMethod:@"POST"];
    
    // 生成 NSURLSessionDataTask 並啟動
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:request completionHandler:completionBlock] resume];
    
}

+ (void)exchangeTokenForUserAccessTokenURLWithCompletionHandler:(HsinYiRequestTokenCompletionHandler)completionBlock
{
    NSString* urlString = [NSString stringWithFormat:@"http://api.kimy.com.tw/Auth/OAuth/Token"];
    NSURL* requestTokenURL = [NSURL URLWithString:urlString];
    
    NSString* reqToken = [[NSUserDefaults standardUserDefaults] valueForKey:requestToken];
    NSString* reqTokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:requestTokenSecret];
    // 取得 header 字串
    NSString *authorizationHeader = [self plainTextAuthorizationHeaderForAppKey:apiKey
                                                                      appSecret:appSecret
                                                                          token:reqToken
                                                                    tokenSecret:reqTokenSecret];
    NSLog(@"header : %@",authorizationHeader);
    NSDictionary* header = [self dictionaryForOAuthRequestHeaderString:authorizationHeader];
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 設定 Header
    [sessionConfig setHTTPAdditionalHeaders:header];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestTokenURL];
    [request setHTTPMethod:@"POST"];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:request completionHandler:completionBlock] resume];



}

// 將回傳值 response 轉成 NSDictionary
+ (NSDictionary *)dictionaryFromOAuthResponseString:(NSString *)response
{
    NSArray *tokens = [response componentsSeparatedByString:@"&"];
    NSMutableDictionary *oauthDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    for(NSString *t in tokens) {
        NSArray *entry = [t componentsSeparatedByString:@"="];
        NSString *key = entry[0];
        NSString *val = entry[1];
        [oauthDict setValue:val forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:oauthDict];
}

// 將 Header 轉成 NSDictionary
+ (NSDictionary *)dictionaryForOAuthRequestHeaderString:(NSString *)request
{
    NSArray *tokens = [request componentsSeparatedByString:@","];
    NSMutableDictionary *oauthDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    for(NSString *t in tokens) {
        NSArray *entry = [t componentsSeparatedByString:@"="];
        NSString *key = entry[0];
        NSString *val = entry[1];
        [oauthDict setValue:val forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:oauthDict];
}

+(NSString*)plainTextAuthorizationHeaderForAppKey:(NSString*)appKey appSecret:(NSString*)appSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret
{
    // version, method, and oauth_consumer_key are always present
    //NSString *header = [NSString stringWithFormat:@"OAuth oauth_version=\"1.0\",oauth_signature_method=\"PLAINTEXT\",oauth_consumer_key=\"%@\"",apiKey];
    
    NSString *header = [NSString stringWithFormat:@"client_key=%@,client_secret=%@",appKey, appSecret];
    
    // look for oauth_token, include if one is passed in
    if (token) {
        header = [header stringByAppendingString:[NSString stringWithFormat:@",request_token=%@",token]];
    }
    
    // add oauth_signature which is app_secret&token_secret , token_secret may not be there yet, just include @"" if it's not there
    if (tokenSecret) {
         header = [header stringByAppendingString:[NSString stringWithFormat:@",signature=%@&%@",appSecret,tokenSecret]];
    }
   
    return header;
}

@end
