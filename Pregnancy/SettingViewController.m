//
//  SettingViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/28.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "SettingViewController.h"
#import "OAuthLoginViewController.h"
#import "HsinYI.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@property (nonatomic, strong) NSArray* headerArray;
@property (nonatomic, strong) NSArray* tableDataArray;


@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 改變 navigation title && leftBarButton 的設置
   self.navigationItem.title = @"設定";
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
//    backBarButtonItem.title = @"";
//    backBarButtonItem.image = [UIImage imageNamed:@"nva_icon02.png"];
//    backBarButtonItem.target = self;
//    backBarButtonItem.action = @selector(back:);
//    
//    // 必須設leftBarButonItem, 不知為何設 backBarButtonItem 無效
//    self.navigationItem.leftBarButtonItem = backBarButtonItem;

    _headerArray = [[NSArray alloc] initWithObjects:@"個人資料",@"關於我們", nil];
    NSArray* sec0Array = [[NSArray alloc] initWithObjects:@"登入會員",@"加入會員",@"會員資料維護",@"寶寶資料維護",@"登出", nil];
    NSArray* sec1Array = [[NSArray alloc] initWithObjects:@"會員權益",@"信誼奇蜜親子網", nil];
    _tableDataArray = [[NSArray alloc] initWithObjects:sec0Array,sec1Array, nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 依照有無 accessToken 來決定是執行的頁面
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
    NSLog(@"accessToken : %@", token);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_tableDataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_tableDataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[_tableDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    tableView.tableHeaderView.backgroundColor = [UIColor redColor];
////    cell.contentView.backgroundColor = [UIColor redColor];
//    return [_headerArray objectAtIndex:section];
//    
////    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
////    if (sectionTitle == nil) {
////        return nil;
////    }
//    
////    UILabel *label = [[UILabel alloc] init];
////    label.frame = CGRectMake(20, 8, 320, 20);
////    label.backgroundColor = [UIColor clearColor];
////    label.textColor = [UIColor blackColor];
////    label.shadowColor = [UIColor grayColor];
////        label.shadowOffset = CGSizeMake(-1.0, 1.0);
////       label.font = [UIFont boldSystemFontOfSize:20];
////       label.text = sectionTitle;
////    
////        UIView *view = [[UIView alloc] init];
////        [view addSubview:label];
////    
////    return view;
//
//}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    NSString *sectionTitle = [_headerArray objectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80) ];
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.text=sectionTitle;
    
    return label;
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"被壓下去的是第%d個Section的第%ld筆Row", indexPath.section,  indexPath.row );
    
    // Section 0
    // 登入會員
    if (indexPath.section == 0 && indexPath.row==0) {
        if ([self isConnectionAvailable])
        {
            NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
            NSLog(@"token : %@", token);
            if (token) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"會員認證"
                                      message:@"目前己經是認證狀態!"
                                      delegate:nil
                                      cancelButtonTitle:@"知道了"
                                      otherButtonTitles:nil];
                [alertView show];
            } else {
//                [self login];
                [self goViewController:@"webSetting" andSetupType:0];
            }
        }

    }
    
    // 加入會員
    if (indexPath.section == 0 && indexPath.row==1) {
        
        if ([self isConnectionAvailable])
        {
            NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
            NSLog(@"token : %@", token);
            if (token) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"會員認證"
                                          message:@"目前己經是奇蜜會員!"
                                          delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                
                [self goViewController:@"webSetting" andSetupType:1];
            }

           

        }
    }
    
    // 會員資料維護
    if (indexPath.section == 0 && indexPath.row==2) {
        
        if ([self isConnectionAvailable])
        {
            NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
            NSLog(@"token : %@", token);
        
            if (token) {
              
                [self goViewController:@"webSetting" andSetupType:2];
            }else{
                [self login];
            }
        }
        
    }
    
    // 寶寶資料維護
    if (indexPath.section == 0 && indexPath.row==3) {
        
        if ([self isConnectionAvailable])
        {
            NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
            NSLog(@"token : %@", token);
            if (token) {
                [self goViewController:@"webSetting" andSetupType:3];
            }else{
                [self login];
            }
        }
        
    }
    
    
    // 登出
    // 清掉 accessToken 和 預產期資料
    if (indexPath.section == 0 && indexPath.row==4) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"EstimatedDate"];

        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:accessToken];
        NSLog(@"token : %@", token);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已經取消授權!";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:2];
        
    }
    // Section 1
    // 會員權益
    if (indexPath.section == 1 && indexPath.row==0) {
        if ([self isConnectionAvailable])
        {
            [self goViewController:@"webSetting" andSetupType:4];
        }
    }
    
    // 信誼奇蜜親子網
    if (indexPath.section == 1 && indexPath.row==1) {
        if ([self isConnectionAvailable])
        {
            [self goViewController:@"webSetting" andSetupType:5];

        }
    }
    
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

-(void)goViewController:(NSString*)viewControllerId andSetupType:(int)setupType
{
    self.appDelegate.setupType= setupType;
    NSString* controllerId = viewControllerId;
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 30;
//    
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
