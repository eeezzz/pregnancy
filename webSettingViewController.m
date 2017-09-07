//
//  webSettingViewController.m
//  Pregnancy
//
//  Created by giming on 2014/4/29.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "webSettingViewController.h"
#import "HsinYI.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface webSettingViewController ()

@end

@implementation webSettingViewController

MBProgressHUD *HUD = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"連線中...";
    self.webView.delegate = self;
    
    int setupType = self.appDelegate.setupType;
    NSString *authorizationURLWithParams;
//
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
    NSLog(@"token : %@", token);
////    if (token) {
        switch (setupType) {
            // 登入會員
            case 0:
                [self getOAuthRequestToken];
                return;
                break;
       
//
            // 加入會員
            case 1:
                authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Member/Register?callback=Pregnancy://userdataupdate"];
                break;
        
            // 會員資料維護
            case 2:
                if (token){
                    authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Member/Profile?access_token=%@&callback=Pregnancy://userdataupdate",token];
                }
                break;
        
            // 寶寶資料維護
            case 3:
                if (token){
                    authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Member/Child?access_token=%@&callback=Pregnancy://userdataupdate",token];
                }
                break;
        
                // 會員權益
            case 4:
                authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Member/About/Join?callback=Pregnancy://userdataupdate"];
                break;
                // 信誼奇蜜親子網
            case 5:
                authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Member/About?callback=Pregnancy://userdataupdate"];
                break;
            default:
                break;
        }
    
        NSURL* url = [[NSURL alloc] initWithString:authorizationURLWithParams];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getOAuthRequestToken
{
    [HsinYI requestTokenWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"responseStr : %@", responseStr);
                NSDictionary *oauthDict = [HsinYI dictionaryFromOAuthResponseString:responseStr];
                
                NSString* oauthTokenKey = oauthDict[requestToken];
                NSString* oauthTokenKeySecret = oauthDict[requestTokenSecret];
                
                //                [[NSUserDefaults standardUserDefaults] setObject:oauthDict[oauthTokenKey] forKey:requestToken];
                //                [[NSUserDefaults standardUserDefaults] setObject:oauthDict[oauthTokenKeySecret] forKey:requestTokenSecret];
                
                [[NSUserDefaults standardUserDefaults] setObject:oauthTokenKey forKey:requestToken];
                [[NSUserDefaults standardUserDefaults] setObject:oauthTokenKeySecret forKey:requestTokenSecret];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //                http://api.kimy.com.tw/Auth/OAuth?callback={callback}
                //                這個位置會判斷Header有沒有Request Token以及Request Token是不是7779D993233E4924B7603D20981FD558
                
                NSLog(@"request_token : %@", [oauthDict objectForKey:@"request_token" ]);
                NSString *reqToken = [[NSUserDefaults standardUserDefaults] valueForKey:requestToken];
                NSLog(@"requestToken : %@", reqToken);
                
                NSString *token = oauthDict[@"request_token"];
                NSString *authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Auth/Login/OAuth?request_token=%@&callback=Pregnancy://userauthorization",token];
                
                // escape codes
                // NSString *escapedURL = [authorizationURLWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                //                [_tokenAlert dismissWithClickedButtonIndex:0 animated:NO];
                
                // opens to user auth page in safari
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:escapedURL]];
                NSURL* url = [[NSURL alloc] initWithString:authorizationURLWithParams];
                NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
                [self.webView loadRequest:request];
                
                
            } else {
                // HANDLE BAD RESPONSE //
                NSLog(@"unexpected response getting token %@",[NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode]);
                NSLog(@"http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                
            }
            
            
            
            
        }
        
    }];
    
}

- (void)exchangeRequestTokenForAccessToken
{
    [HsinYI exchangeTokenForUserAccessTokenURLWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSLog(@"succ");
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                NSLog(@"OAuthView.exchangeRequestTokenForAccessToken->http response  : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"OAuthView.exchangeRequestTokenForAccessToken->responseStr : %@", responseStr);
                NSDictionary *accessTokenDict = [HsinYI dictionaryFromOAuthResponseString:responseStr];
                
                NSLog(@"OAuthView.exchangeRequestTokenForAccessToken->accessToken : %@", [accessTokenDict objectForKey:accessToken ]);
                
                
                NSString* oauthTokenKey = accessTokenDict[accessToken];
                NSString* oauthTokenKeySecret = accessTokenDict[accessTokenSecret];
                //                [[NSUserDefaults standardUserDefaults] setObject:accessTokenDict[oauthTokenKey] forKey:accessToken];
                //                [[NSUserDefaults standardUserDefaults] setObject:accessTokenDict[oauthTokenKeySecret] forKey:accessTokenSecret];
                
                [[NSUserDefaults standardUserDefaults] setObject:oauthTokenKey forKey:accessToken];
                [[NSUserDefaults standardUserDefaults] setObject:oauthTokenKeySecret forKey:accessTokenSecret];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
                NSLog(@"OAuthView.exchangeRequestTokenForAccessToken->accessToken : %@", token);                // now load main part of application
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                    NSString *segueId = @"TabBar";
                    //                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                    //                    UITabBarController *initViewController = [storyboard instantiateViewControllerWithIdentifier:segueId];
                    //
                    //                    UINavigationController *nav = (UINavigationController *) self.window.rootViewController;
                    //                    nav.navigationBar.hidden = YES;
                    //                    [nav pushViewController:initViewController animated:NO];
                    //                    UIStoryboard* storyboard;
                    //                    NSString *controllerId =  @"TabBar" ;
                    //                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    //                    {
                    //                        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                    //                    }else
                    //                    {
                    //                        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                    //                    }
                    //
                    //                    UITabBarController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
                    //                    [initViewController setSelectedIndex:0];
                    //                    //                    [self presentViewController:initViewController  animated:NO completion:nil];
                    //                    [self.window setRootViewController:initViewController];
                    //
                    //
                    //                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //                        [self getPregnancyDate];
                    //                        [self uploadDeviceTokenWithAccessToken];
                    
                    //                    });
                     [self getPregnancyDate];
                               [self dismissViewControllerAnimated:YES completion:nil ];
                });
                
            } else {
                // HANDLE BAD RESPONSE //
                // 本例是回傳 httpResp.statusCode == 401;
                NSLog(@"http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                NSLog(@"exchange request for access token unexpected response %@",
                      [NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode]);
            }
        } else {
            // ALWAYS HANDLE ERRORS :-] //
        }
        
    }];
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        WebSiteViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebSiteViewController"];
        //        vc.url = request.URL.absoluteString;
        NSString* url = request.URL.absoluteString;
        NSLog(@"viewController.link is : %@",  url);
        //        [self.navigationController pushViewController:vc animated:YES];
        if ([[url substringToIndex:29] isEqualToString:@"pregnancy://userauthorization" ]) {
            // todo: 寫入accessToken
//            _appDelegate.authed = true;
//            self.label.text = @"取得授權";
            [self exchangeRequestTokenForAccessToken];
           
            
            
//            [self dismissViewControllerAnimated:YES completion:nil ];
        }else{
//            self.label.text = @"授權失敗";
        }
        //        return false;
        //        
//    }
    //
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exitTouch:(UIButton *)sender {
    if (self.appDelegate.setupType==3) {
        [self getPregnancyDate];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getPregnancyDate
{
    NSLog(@"Appdelegate.getPregnancyDate->to Geting");
    
    
    NSString *accToken = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
    NSString* authorzationValue = [NSString stringWithFormat:@"Bearer %@", accToken];
    NSString* urlStr = [NSString stringWithFormat: @"http://api.kimy.com.tw/Member/api/Child/DueDate"];
    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:reqToken,@"request_token",nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue: authorzationValue forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = @"GET";
    //
    //    NSString* bodyString = [NSString stringWithFormat:@"deviceId=%@",deviceTokenStr];
    //    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError* error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!error) {
        NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*) response;
        // 進行 statusCode:200 的處理
        
        NSLog(@"AppDelegate.getPregnancyDate->httpResp.statusCode : %ld", (long)httpResp.statusCode);
        if (httpResp.statusCode == 200) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"***************");
            NSLog(@"***************");
            NSLog(@"***************");
            NSLog(@"AppDelegate.getPregnancyDate->result : %@", result);
            NSLog(@"***************");
            NSLog(@"***************");
            NSLog(@"***************");
            
            NSArray *entry = [result componentsSeparatedByString:@"="];
            NSString *key = entry[0];
            NSString *val = entry[1];
            
            
            // 將DeviceToken保存在NSUserDefaults
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:val forKey:@"EstimatedDate"];
            
            NSString *estimate = [[NSUserDefaults standardUserDefaults] valueForKey:@"EstimatedDate"];
            NSLog(@"AppDelegate.getPregnancyDate->estimate : %@", estimate);
            
            
            //
            //            NSLog(@"AppDelegate.uploadDeviceToken->[userDefaults objectForKey:DeviceTokenStringKey] : %@", [userDefaults objectForKey:DeviceTokenStringKey] );
        }
    }
    
    
    
    
}

@end
