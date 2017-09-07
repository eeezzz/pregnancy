//
//  askWebViewController.m
//  Pregnancy
//
//  Created by giming on 2014/4/29.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "askWebViewController.h"
#import "HsinYI.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface askWebViewController ()

@end

@implementation askWebViewController


MBProgressHUD *HUD2 = nil;

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
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    HUD2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD2.labelText = @"連線中...";
    self.webView.delegate = self;
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
    NSString *authorizationURLWithParams;
    authorizationURLWithParams = [NSString stringWithFormat:@"http://store.kimy.com.tw/App/PregnancyBag/Bag.aspx?access_token=%@&callback=Pregnancy://Bag",token];
    NSURL* url = [[NSURL alloc] initWithString:authorizationURLWithParams];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD2 hide:YES];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


