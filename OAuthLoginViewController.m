//
//  OAuthLoginViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/30.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "OAuthLoginViewController.h"
#import "HsinYI.h"

#import "Reachability.h"
#import "MBProgressHUD.h"


@interface OAuthLoginViewController ()


@property (nonatomic, strong) UIAlertView *tokenAlert;


@end

@implementation OAuthLoginViewController

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
    [super viewDidAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
    NSLog(@"token : %@", token);
    if (token) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
    self.view.BackgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
}



- (IBAction)login:(UIButton *)sender {
    if ([self isConnectionAvailable]) {
   
//        // show alert view saying we are getting token
//        _tokenAlert = [[UIAlertView alloc] initWithTitle:@"取得授權"
//                                             message:@"進入信誼授權畫面-請稍後"
//                                            delegate:nil
//                                   cancelButtonTitle:@"取消"
//                                   otherButtonTitles:nil];
//        [_tokenAlert show];
//        [self getOAuthRequestToken];
        self.appDelegate.setupType = 0;
        NSString* controllerId = @"webSetting";
        UIStoryboard* storyboard;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            // iPhone 大小的調整
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }else{
             storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        }
        UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
        [self presentViewController:initViewController  animated:YES completion:nil];    }
    
}

-(IBAction)backToApp:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
                NSString *escapedURL = [authorizationURLWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [_tokenAlert dismissWithClickedButtonIndex:0 animated:NO];
                
                // opens to user auth page in safari
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escapedURL]];
                
                
                
            } else {
                // HANDLE BAD RESPONSE //
                NSLog(@"unexpected response getting token %@",[NSHTTPURLResponse localizedStringForStatusCode:httpResp.statusCode]);
                NSLog(@"http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                
            }
            
            
            
            
        }
        
    }];
    
}
-(BOOL)isConnectionAvailable
{
    BOOL isExistNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistNetwork = YES;
            break;
    }
    
    if (!isExistNetwork) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"當前網路不可用，請檢查網路連接!";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:2];
    }
    
    return isExistNetwork;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
