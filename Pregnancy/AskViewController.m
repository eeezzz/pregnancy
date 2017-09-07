//
//  AskViewController.m
//  Pregnancy
//
//  Created by giming on 2014/4/3.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "AskViewController.h"
#import "HsinYI.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface AskViewController ()

@end

@implementation AskViewController

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
    // Do any additional setup after loading the view.
    
    

//        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
//        NSLog(@"token : %@", token);
//        if (token) {
//            NSString *authorizationURLWithParams = [NSString stringWithFormat:@"http://store.kimy.com.tw/App/PregnancyBag/Bag.aspx?access_token=%@&callback=Pregnancy://Bag",token];
//            // escape codes
//            NSString *escapedURL = [authorizationURLWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            // opens to user auth page in safari
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escapedURL]];
//        }else{
//            [self login];
//        }
    
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:235.0/255.0 alpha:1.0];
    
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)askWebView
{
    NSString* controllerId = @"askWebView";
    UIStoryboard* storyboard;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }else{
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    
    
    
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    [self presentViewController:initViewController  animated:YES completion:nil];
    
}

-(void)login
{
    
    NSString* controllerId = @"Login";
    UIStoryboard* storyboard;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }else{
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    [self presentViewController:initViewController  animated:YES completion:nil];
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

- (IBAction)askBag:(UIButton *)sender {
//    if ([self isConnectionAvailable])
//    {
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
        NSLog(@"token : %@", token);
        if (token) {
//            NSString *authorizationURLWithParams = [NSString stringWithFormat:@"http://store.kimy.com.tw/App/PregnancyBag/Bag.aspx?access_token=%@&callback=Pregnancy://Bag",token];
//            // escape codes
//            NSString *escapedURL = [authorizationURLWithParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            // opens to user auth page in safari
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escapedURL]];
            [self askWebView];
        }else{
            [self login];
        }
//    }
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
@end
