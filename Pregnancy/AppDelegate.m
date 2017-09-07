//
//  AppDelegate.m
//  Pregnancy
//
//  Created by giming on 2014/3/1.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "HsinYI.h"

#import "SettingViewController.h"
#import "IIViewDeckController.h"
#import "MBProgressHUD.h"
#import "UpdateEntity.h"
#import "Infos.h"

@implementation AppDelegate

NSString * const DeviceTokenStringKey = @"deviceTokenStringKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // for side menu
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    
    if (notification) {
        
        [self showAlarm:notification.alertBody];
        
        NSLog(@"AppDelegate didFinishLaunchingWithOptions");
        
        application.applicationIconBadgeNumber = 0;
        
    }
    
    NSString* verStr = [NSString stringWithFormat:@"Version %@ (%@)", [[[NSBundle mainBundle] infoDictionary]
                                                    objectForKey:@"CFBundleVersion"] , @"0"];
    NSLog(@"%@",verStr);
    
    
    
    
    UIStoryboard *storyboard;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
         storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    
    NSString *controllerId;
    
    int try = 1;
    
    switch (try) {
        case 1:
            // 更新頁面
            controllerId = @"Update";
                        break;
        case 2:
            // TabBar頁面
            controllerId = @"TabBar";
            
            break;
        default:
            
            break;
            
    }
    
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    
    switch (try) {
        case 1:
           [self.window setRootViewController:initViewController];
//            [(UINavigationController*) self.window.rootViewController pushViewController:initViewController animated:NO];
            break;
        case 2:
//            [(UINavigationController*) self.window.rootViewController pushViewController:initViewController animated:NO];
//            [self initViewDeck];
                      [self.window setRootViewController:initViewController];
            
        default:
            break;
    }
    
    
    // 設定圖檔緩衝cache
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CusstomPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    // 客制化設定
    [self customTabBarAndNavigationBar];

    return YES;
}




-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    NSLog(@"url scheme : %@", [url scheme]);
    NSLog(@"url path:%@", [url path]);
    if ([[NSString stringWithFormat:@"%@", url] isEqualToString:@"pregnancy://userdataupdate"]) {
        [self getPregnancyDate];
//        [self.window.rootViewController.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    

    
    
    
    if ([[url scheme] isEqualToString:@"pregnancy"]) {
        NSLog(@"URL %@",url);
        
        [self exchangeRequestTokenForAccessToken];
    }
    return NO;
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
                NSLog(@"AppDelete.exchangeRequestTokenForAccessToken->http response  : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"AppDelete.exchangeRequestTokenForAccessToken->responseStr : %@", responseStr);
                NSDictionary *accessTokenDict = [HsinYI dictionaryFromOAuthResponseString:responseStr];
               
                NSLog(@"AppDelete.exchangeRequestTokenForAccessToken->accessToken : %@", [accessTokenDict objectForKey:accessToken ]);
               
                
                NSString* oauthTokenKey = accessTokenDict[accessToken];
                NSString* oauthTokenKeySecret = accessTokenDict[accessTokenSecret];
//                [[NSUserDefaults standardUserDefaults] setObject:accessTokenDict[oauthTokenKey] forKey:accessToken];
//                [[NSUserDefaults standardUserDefaults] setObject:accessTokenDict[oauthTokenKeySecret] forKey:accessTokenSecret];
                
                [[NSUserDefaults standardUserDefaults] setObject:oauthTokenKey forKey:accessToken];
                [[NSUserDefaults standardUserDefaults] setObject:oauthTokenKeySecret forKey:accessTokenSecret];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                 NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
                NSLog(@"AppDelete.exchangeRequestTokenForAccessToken->accessToken : %@", token);                // now load main part of application
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //                    NSString *segueId = @"TabBar";
                    //                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                    //                    UITabBarController *initViewController = [storyboard instantiateViewControllerWithIdentifier:segueId];
                    //
                    //                    UINavigationController *nav = (UINavigationController *) self.window.rootViewController;
                    //                    nav.navigationBar.hidden = YES;
                    //                    [nav pushViewController:initViewController animated:NO];
                    UIStoryboard* storyboard;
                    NSString *controllerId =  @"TabBar" ;
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                    {
                        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                    }else
                    {
                        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                    }
                    
                    UITabBarController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
                    [initViewController setSelectedIndex:0];
//                    [self presentViewController:initViewController  animated:NO completion:nil];
                    [self.window setRootViewController:initViewController];
                    
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [self getPregnancyDate];
                        [self uploadDeviceTokenWithAccessToken];
                       
                    });
                    
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






- (void)customTabBarAndNavigationBar
{
    // Change the tabbar's background and selection image through the appearance proxy
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selection.png"]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:235.0/255.0 green:55.0/255.0 blue:140.0/255.0 alpha:1.0]];

    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(1, 2);
    
    //     [[UITabBar appearance]
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0],
                                                           NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:25.0],
                                                           NSShadowAttributeName : shadow
                                                           }];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0]];
    

}

// 使用者允許遠端 notification 時會被自動回調
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // deviceToken 的格式是 <72993ff3 6117e7ac 93a09c45 a6c3b465 5873df79 eb4949e1 934a1d66 c42dc7d2>
    // 但實際發送的 deviceToken 是 72993ff36117e7ac93a09c45a6c3b4655873df79eb4949e1934a1d66c42dc7d2
    // 所以須將 '<', ' ', '>' 三種字元清除
    NSString* deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"AppDelegate.didRegisterForRemoteNotificationsWithDeviceToken->tokenString: %@", deviceTokenStr);
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // send deviceToken to our server
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
        if ( ![userDefaults boolForKey:DeviceTokenStringKey] )
        {
            NSLog(@"AppDelegate.didRegisterForRemoteNotificationsWithDeviceToken->連至WebApi注冊deviceToken");
            // 連至WebApi注冊deviceToken
            [self sendProviderDeviceToken:deviceTokenStr];
            
        }
        
    });
    

}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", [error localizedDescription]);
}


//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    //当用户打开程序时候收到远程通知后执行
//    if (application.applicationState == UIApplicationStateActive) {
//        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:[NSString stringWithFormat:@"\n%@",
//                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        
//        dispatch_async(dispatch_get_global_queue(0,0), ^{
//            //hide the badge
//            application.applicationIconBadgeNumber = 0;
//            
//            //ask the provider to set the BadgeNumber to zero
//            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            //            NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
//            //            [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
//        });
//        
//        [alertView show];
//        
//        
//    }}
// 當用戶打開遠程通知，會被回調
// 可以在這裡寫讀取後的後續操作，
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"received badge number ---%@ ----",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
//    NSLog(@"the badge number is  %d",  [[UIApplication sharedApplication] applicationIconBadgeNumber]);
//    NSLog(@"the application  badge number is  %d",  application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber += 1;
    
    
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
    
    //当用户打开程序时候收到远程通知后执行
    if (application.applicationState == UIApplicationStateActive) {
    // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                    message:[NSString stringWithFormat:@"\n%@",
//                                    [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
//                                    delegate:self
//                                    cancelButtonTitle:@"OK"
//                                    otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //hide the badge
            application.applicationIconBadgeNumber = 0;
            
            //ask the provider to set the BadgeNumber to zero
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
//            [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
                   });
        
              [self showAlarm:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];

        
   }
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 當用戶正打開本程序時收到遠程通知時執行
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //hide the badge
            application.applicationIconBadgeNumber = 0;
            
            //ask the provider to set the BadgeNumber to zero
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //            NSString *deviceTokenStr = [userDefaults objectForKey:DeviceTokenStringKEY];
            //            [self resetBadgeNumberOnProviderWithDeviceToken:deviceTokenStr];
        });
        
        [self showAlarm:notification.alertBody];
    }

    
}

- (void)showAlarm:(NSString *)text {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
}

-(void)resetBadgeNumberOnProviderWithDeviceToken:(NSString*)deviceTokenString
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self getUpdate];
}

// 每次醒來都會被呼叫
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 沒有到我們的 Server 註冊 deviceToken, 就走一次原始流程, 向APNS申請發送 notification
    if (![userDefaults boolForKey:DeviceTokenStringKey]) {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
    }
    

    // DoTo
    // 檢查有無新版更新寫在這裡
    
    application.applicationIconBadgeNumber = 0;
    
//    [self getUpdate];
    
}

-(BOOL)getUpdate
{
//    MBProgressHUD *_hud;
    // 設置 NSURLSessionConfiguration
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    // 以即有的 NSURLSessionConfiguration 設置 NSURLSession
    NSURLSession* _session =[NSURLSession sessionWithConfiguration:config];
    // 設置 WebAPI 的 NSURL 給接續的 NSURLSessionDataTask 使用
    //  NSString* urlStr = @"http://api.kimy.com.tw/Intra/api/PregnancyApp/BaiKe";
    //    NSString* urlStr = @"http://api.kimy.com.tw/Intra/api/PregnancyApp";
    NSString* urlStr = @"http://api.kimy.com.tw/content/api/PregnancyApp";
    
    NSString* lastUpdate;
    lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdatDate"];
    NSLog(@"AppDelegate.getUpdate->lastUpdate : %@", lastUpdate);
    
    if ([lastUpdate isEqualToString:[self getTodayString]]) {
            return NO;
       }
    
    if (!(lastUpdate == nil)) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/%@",lastUpdate]];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 顯示網路儲存動態圖示
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    _hud = [MBProgressHUD showHUDAddedTo:self.v animated:YES];
//    //    _hud.mode = MBProgressHUDModeText;
//    _hud.labelText = @"更新中，請稍後";
    //設定背景
//    UIImage *pattern = [UIImage imageNamed:@"bg.png"];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
    //建立UIActivityIndicatorView並設定風格
    //    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //開始UIActivityIndicatorView動畫（旋轉效果）
    //    [indicator startAnimating];
    //設定位置並加入畫面
    //    indicator.center = CGPointMake(160, 450);
    //    [self.view addSubview:indicator];
    
    // WebAPI 呼叫
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //  沒有回應任何錯誤
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*) response;
            // 進行 statusCode:200 的處理
            if (httpResp.statusCode == 200) {
                NSError* jsonError;
                // 將傳回JSON的資料，以 NSArray 儲存
                // 以目前 WebAPI 的回傳內容，系統會以2維陣列來存放
                // 1維儲存內容陣列，1維儲存內容
                NSArray *updateJSON = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:NSJSONReadingAllowFragments
                                       error:&jsonError];
                if (!jsonError) {
                    
                    // 以一個array存放傳回來的JSON轉換IOS能處理的資料
                    //                    NSMutableArray* entityFound = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *metadata in updateJSON) {
                        UpdateEntity* entity = [[UpdateEntity alloc] initWithJsonData:metadata];
                        NSLog(@"entity.type : %@", entity.type);
                        NSLog(@"entity.status : %@", entity.status);
                        NSLog(@"entity.id : %@",entity.itemId);
                        NSLog(@"entity.title : %@", entity.title);
                        NSLog(@"entity.beginDate : %@", entity.beginDate);
                        NSLog(@"entity.endDate : %@", entity.endDate);
                        NSLog(@"entity.photoName : %@", entity.photoName);
                        NSLog(@" ----------------------------");
                        
                        // 這裡做新增,修改的處理
                        if ([entity.status  isEqual: @"C"]) {
                            [self addInfosInItemid:entity.itemId withTitle:entity.title WithContent:entity.content WithPhotoName:entity.photoName WithType:entity.type WithBeginDate:entity.beginDate AndEndDate:entity.endDate];
                            [self saveContext];
                        }
                        // 這裡做刪除的處理
                        if ([entity.status isEqual: @"D"]) {
                            [self deleteInfosInItemid:entity.itemId AndType:entity.type];
                        }
                        
                        
                        //                        [entityFound addObject:entity];
                        
                        
                        
                    }
                    
                    NSString* lastUpdateStr = [self getTodayString];
                    NSLog(@"AppDelegate.getUpdate->lastUpdate : %@", lastUpdateStr);
                    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateStr forKey:@"lastUpdatDate"];
                    // 將轉換的資料直接設給tableView所依賴的Array
                    //                    self.BaiKes = entityFound;
                    
                    // 呼叫主線程來做畫面的更新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 關閉網路儲存動態圖示
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        //                        [indicator stopAnimating];
                        //                        // 關閉下拉更新元件的動態圖示
                        //                        [self.refreshControl endRefreshing];
                        //                        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
                        //                        // 重置TabView
                        //                        [self.tableView reloadData];
 
                        
                        //                        if (self.errored) {
                        
                        
                        
                        //                        NSString* lastUpdateStr = [self getTodayString];
                        //                        NSLog(@"updateViewController.update->lastUpdate : %@", lastUpdateStr);
                        //                        [[NSUserDefaults standardUserDefaults] setObject:lastUpdateStr forKey:@"lastUpdatDate"];
                        
                        //                        NSString* readdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdatDate"];
                        //                        NSLog(@"UpdateViewController.update->lastUpdate : %@", readdate);
//                        [self backTabBarController];
                        //                        }
                        
                    });
                }
            }
            else
            {
                // 關閉網路儲存動態圖示
                
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"AppDelegate.getUpdate->http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alertView = [[UIAlertView alloc]
//                                              initWithTitle:@"Updating Error"
//                                              message:@"呼叫API時發生錯誤"
//                                              delegate:self
//                                              cancelButtonTitle:@"關閉"
//                                              otherButtonTitles:@"重試",nil];
//                    [alertView show];
//                    
//                });
                
            }
            
        } else {
            
            NSLog(@"AppDelegate.getUpdate->dataTask level error : %@", error.description);
//            // 回到主線程顯示錯誤訊息
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alertView = [[UIAlertView alloc]
//                                          initWithTitle:@"Updating Error"
//                                          message:[error.userInfo objectForKey:@"NSLocalizedDescription"]
//                                          delegate:self
//                                          cancelButtonTitle:@"關閉"
//                                          otherButtonTitles:@"重試",@"進入好孕館",nil];
//                [alertView show];
//                
//            });
        }
        
    }];
    
    // 啟動 NSURLSessionDataTask
    [dataTask resume];
    
    return YES;
    
}


-(NSString*)getTodayString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    NSString* today = [dateFormatter stringFromDate:now];
    
    NSLog(@"AppDelegate.getUpdate->today : %@", today);
    return today;
}

-(BOOL)addInfosInItemid:(NSNumber*)itemId withTitle:(NSString*)  title WithContent:(NSString*) content WithPhotoName:(NSString*)photoName WithType:(NSString*)type WithBeginDate:(NSString*)beginDate AndEndDate:(NSString*)endDate
{
    if (!itemId || !type) {
        return NO;
    }
    
    Infos* infosObject = [self getInfosByItemId:itemId AndType:type];
    
    if (infosObject == nil) {
        infosObject = [NSEntityDescription insertNewObjectForEntityForName:@"Infos" inManagedObjectContext:[self managedObjectContext]];
    }
    infosObject.type = type;
    infosObject.itemId = itemId;
    infosObject.title = title;
    infosObject.content = content;
    infosObject.photoName = photoName;
    infosObject.beginDate = beginDate;
    infosObject.endDate = endDate;
    
    return YES;
}

-(BOOL)deleteInfosInItemid:(NSNumber*)itemId AndType:(NSString*)type
{
    if (!itemId || !type) {
        return NO;
    }
    
    //    Infos* InfosObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* baiKeEntity = [NSEntityDescription
                                        entityForName:@"Infos"
                                        inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:baiKeEntity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"itemId == %@ && type = %@", itemId, type];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
        
    }
    
    if (array && [array count] > 0) {
        [self.managedObjectContext deleteObject:[array objectAtIndex:0]];
    }
    
    return YES;
}

-(Infos*)getInfosByItemId:(NSNumber*)itemId AndType:(NSString*)type
{
    Infos* InfosObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* baiKeEntity = [NSEntityDescription
                                        entityForName:@"Infos"
                                        inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:baiKeEntity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"itemId == %@ && type = %@", itemId, type];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
        
    }
    
    if (array && [array count] > 0) {
        InfosObject = [array objectAtIndex:0];
    }
    
    return InfosObject;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Getting Device toen for Notification support

// 向APNS申請發送 notification
-(void)registerForRemoteNotificationToGetToken
{
    NSLog(@"AppDelegate.registerForRemoteNotificationToGetToken->Registering for push notifications...");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 如果沒有註冊到DeviceToken，則重新發送注冊請求
    if (![userDefaults boolForKey:@"DeviceTokenRegisteredKEY"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeNewsstandContentAvailability |
              UIRemoteNotificationTypeBadge |
              UIRemoteNotificationTypeSound |
              UIRemoteNotificationTypeAlert)];
            
        });
    }
    
}
-(void)sendProviderDeviceToken:(NSString*)deviceTokenStr
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
                
                //                NSLog(@"request_token : %@", [oauthDict objectForKey:@"request_token" ]);
                //                NSString *reqToken = [[NSUserDefaults standardUserDefaults] valueForKey:requestToken];
                //                NSLog(@"requestToken : %@", reqToken);
                
                //                NSString *token = oauthDict[@"request_token"];
                //                NSString *authorizationURLWithParams = [NSString stringWithFormat:@"http://api.kimy.com.tw/Auth/Login/OAuth?request_token=%@&callback=Pregnancy://userauthorization",token];
                //
                //                // escape codes
                //                NSString *escapedURL = [authorizationURLWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //
                //                [_tokenAlert dismissWithClickedButtonIndex:0 animated:NO];
                //
                //                // opens to user auth page in safari
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escapedURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self uploadDeviceToken:deviceTokenStr];
                });
            } else {
                // HANDLE BAD RESPONSE //
                NSLog(@"unexpected response getting token %@",[NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode]);
                NSLog(@"http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                
            }
            
            
            
            
        }
        
    }];
    

}

-(void) uploadDeviceTokenWithAccessToken
{
    #if (TARGET_IPHONE_SIMULATOR)
    return;

    #endif
    
    NSString* deviceToKenStr = [[NSUserDefaults standardUserDefaults] valueForKeyPath:DeviceTokenStringKey];
    if (deviceToKenStr == nil) {
        NSString *accToken = [[NSUserDefaults standardUserDefaults] valueForKeyPath:accessToken];
        NSString* authorzationValue = [NSString stringWithFormat:@"Bearer %@", accToken];
        NSString* urlStr = [NSString stringWithFormat: @"http://api.kimy.com.tw/Auth/OAuth/MachineAuth"];
        NSURL *url = [NSURL URLWithString:urlStr];
        //    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:reqToken,@"request_token",nil];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request addValue: authorzationValue forHTTPHeaderField:@"Authorization"];
        request.HTTPMethod = @"POST";

        //    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:reqToken,@"request_token",nil];

        NSString* bodyString = [NSString stringWithFormat:@"deviceId=%@",deviceToKenStr];
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
        NSError* error = nil;
        NSURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (!error) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*) response;
            // 進行 statusCode:200 的處理
            NSLog(@"AppDelegate.uploadDeviceTokenWithAccessToken->httpResp.statusCode : %ld", (long)httpResp.statusCode);
            if (httpResp.statusCode == 200) {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"AppDelegate.uploadDeviceTokenWithAccessToken->result : %@", result);

            }
        }
    }

}

-(void) uploadDeviceToken:(NSString*)deviceTokenStr
{
    NSString *reqToken = [[NSUserDefaults standardUserDefaults] valueForKey:requestToken];
    NSString* urlStr = [NSString stringWithFormat: @"http://api.kimy.com.tw/Auth/OAuth/Machine"];
    NSURL *url = [NSURL URLWithString:urlStr];
//    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:reqToken,@"request_token",nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue: reqToken forHTTPHeaderField:@"request_token"];
    request.HTTPMethod = @"POST";
    //
    NSString* bodyString = [NSString stringWithFormat:@"deviceId=%@",deviceTokenStr];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError* error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!error) {
        NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*) response;
        // 進行 statusCode:200 的處理
        NSLog(@"AppDelegate.uploadDeviceToken->httpResp.statusCode : %ld", (long)httpResp.statusCode);
        if (httpResp.statusCode == 200) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"AppDelegate.uploadDeviceToken->result : %@", result);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // 將DeviceToken保存在NSUserDefaults
            [userDefaults setObject:deviceTokenStr forKey:DeviceTokenStringKey];
            
            NSLog(@"AppDelegate.uploadDeviceToken->[userDefaults objectForKey:DeviceTokenStringKey] : %@", [userDefaults objectForKey:DeviceTokenStringKey] );
        }
    }
}


#pragma mark - Application's Documents directory

/**
 取得應用程式Documents目錄的子路徑.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}



/**
 傳回被初始化過的NSPersistentStoreCoordinator物件
 如果已經初始化過就直接傳回
 不然就開啟Documents下的data.sqlite檔案
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // 如果已經初始化就直接傳回
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    // 從Documents目錄下指定物件的路徑
    NSLog(@"DocumentDirectory ->%@",[self applicationDocumentsDirectory]);
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"mydata16.sqlite"];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    // 初始化並傳回
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator
          addPersistentStoreWithType:NSSQLiteStoreType
          configuration:nil
          URL:storeURL
          options:options
          error:&error])
    {
        
        NSLog(@"在存取資料庫時發生不可預期的錯誤 %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

/**
 從Data Model檔中建立NSManagedObjectModel物件
 如果已經建立會直接回傳而不用再次讀取
 */
- (NSManagedObjectModel *)managedObjectModel
{
    //如果物件已經初始化過就直接回傳
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    // 沒有的話就直接載入該檔案之後回傳
    // 在URLForResource中傳入書名
    NSURL *modelURL = [[NSBundle mainBundle]
                       URLForResource:@"dataModel" withExtension:@"momd"];
    // 從Model檔案中實例化m_managedObjectModel
    _managedObjectModel = [[NSManagedObjectModel alloc]
                            initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 傳回這個應用程式的NSManagedObjectContext物件
 如果已經存在就直接回傳，不然就從sql-lite中
 藉由persistentStoreCoordinator中讀取
 */
- (NSManagedObjectContext *)managedObjectContext
{
    // 如果物件已經初始化就直接回傳
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    // 不然就使用persistentStoreCoordinator從資料庫中讀取
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// 將資料儲存進managedObjectContext中
- (void)saveContext
{
    NSError *error = nil;
    // 取得NSManagedObjectContext物件
    NSManagedObjectContext *managedObjectContext =
    [self managedObjectContext];
    // 如果存在就進行儲存的動作
    if (managedObjectContext != nil)
    {
        // 如果資料有變更就進行儲存
        if ([managedObjectContext hasChanges] &&
            ![managedObjectContext save:&error])
        {
            // 資料儲存發生錯誤
            NSLog(@"Unresolved error %@, %@",
                  error, [error userInfo]);
            abort();
        }
    }
}

- (IIViewDeckController*)generateControllerStack {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NSString *controllerId= @"Setting";
    SettingViewController* rightViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    
    controllerId= @"TabBar";
    
    UITabBarController *centerController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                                    leftViewController:rightViewController
                                                                                   rightViewController:rightViewController];
    deckController.rightSize = 100;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}

@end
