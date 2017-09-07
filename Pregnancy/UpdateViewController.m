//
//  UpdateViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/24.
//  Copyright (c) 2014年 giming. All rights reserved.


#import "UpdateViewController.h"
#import "MBProgressHUD.h"

#import "HaoKang.h"
#import "BaiKeEntity.h"
#import "BaiKe.h"
#import "UpdateEntity.h"
#import "AppDelegate.h"
#import "HsinYI.h"

#import "Infos.h"


@interface UpdateViewController ()

@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSArray* BaiKes;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, weak) MBProgressHUD *hud;

@end

@implementation UpdateViewController

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

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 取得應用程式的代理物件參照
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    
	// Do any additional setup after loading the view.
    //    [(UINavigationController*) self.window.rootViewController pushViewController:initViewController animated:NO];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    
    
    // 這裡判斷是否第一次
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    //
    //        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"第一次"
    //                                                        message:@"進入App"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"我知道了"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //
    //
    //    }
    
    /*
     1執行UpdateViewController
     2判斷是否剛下載使用
     */
//    NSString* lastUpdate;
//    lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdatDate"];
//    NSLog(@"UpdateViewController.viewDidLoad->lastUpdate : %@", lastUpdate);
//    if (![lastUpdate isEqualToString:[self getTodayString]]) {
        [self update];
//    }

//    [self backTabBarController];

}


-(BOOL) update
{
    
    
    // 設置 NSURLSessionConfiguration
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    // 以即有的 NSURLSessionConfiguration 設置 NSURLSession
    _session =[NSURLSession sessionWithConfiguration:config];
    // 設置 WebAPI 的 NSURL 給接續的 NSURLSessionDataTask 使用
//  NSString* urlStr = @"http://api.kimy.com.tw/Intra/api/PregnancyApp/BaiKe";
//    NSString* urlStr = @"http://api.kimy.com.tw/Intra/api/PregnancyApp";
       NSString* urlStr = @"http://api.kimy.com.tw/content/api/PregnancyApp";
    
    NSString* lastUpdate;
    lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdatDate"];
    NSLog(@"UpdateViewController.update->lastUpdate : %@", lastUpdate);
    
//    if ([lastUpdate isEqualToString:[self getTodayString]]) {
//        return NO;
//    }
    if (!(lastUpdate == nil)) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/%@",lastUpdate]];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 顯示網路儲存動態圖示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"更新中，請稍後";
    //設定背景
    UIImage *pattern = [UIImage imageNamed:@"bg.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
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
                            [_appDelegate saveContext];
                        }
                        // 這裡做刪除的處理
                        if ([entity.status isEqual: @"D"]) {
                            [self deleteInfosInItemid:entity.itemId AndType:entity.type];
                        }

                        
//                        [entityFound addObject:entity];
                        
                        
                        
                    }
                    
                    NSString* lastUpdateStr = [self getTodayString];
                    NSLog(@"updateViewController.update->lastUpdate : %@", lastUpdateStr);
                    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateStr forKey:@"lastUpdatDate"];
                    // 將轉換的資料直接設給tableView所依賴的Array
//                    self.BaiKes = entityFound;
                    
                    // 呼叫主線程來做畫面的更新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 關閉網路儲存動態圖示
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                        [indicator stopAnimating];
//                        // 關閉下拉更新元件的動態圖示
//                        [self.refreshControl endRefreshing];
//                        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//                        // 重置TabView
//                        [self.tableView reloadData];
                        [UIView animateWithDuration:5.0 animations:^{
                            _messageLabel.alpha = 0;
                        }];

//                        if (self.errored) {
                        
                        

//                        NSString* lastUpdateStr = [self getTodayString];
//                        NSLog(@"updateViewController.update->lastUpdate : %@", lastUpdateStr);
//                        [[NSUserDefaults standardUserDefaults] setObject:lastUpdateStr forKey:@"lastUpdatDate"];
                        
//                        NSString* readdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdatDate"];
//                        NSLog(@"UpdateViewController.update->lastUpdate : %@", readdate);
                            [self backTabBarController];
//                        }
                        
                    });
                }
            }
            else
            {
                // 關閉網路儲存動態圖示
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Updating Error"
                                          message:@"呼叫API時發生錯誤"
                                          delegate:self
                                          cancelButtonTitle:@"關閉"
                                          otherButtonTitles:@"重試",nil];
                    [alertView show];
                    
                });
                
            }
            
        } else {
            //[error.userInfo objectForKey:@"NSLocalizedDescription"]
            NSLog(@"dataTask level error : %@", error.description);
            // 回到主線程顯示錯誤訊息
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"更新錯誤"
                                          message: @"~請檢查目前internet的連線狀態~"
                                          delegate:self
                                          cancelButtonTitle:@"關閉"
                                          otherButtonTitles:@"重試",@"進入好孕館",nil];
                [alertView show];
                
            });
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
    
    NSLog(@"updateViewController.update->today : %@", today);
    return today;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
           abort();
            break;
            
        case 1:
            
 
            [self update];
            

           
            break;
        case 2:
            [self backTabBarController];
            break;
        default:
            break;
    }
    //[self backLogin];
}


-(BOOL)addInfosInItemid:(NSNumber*)itemId withTitle:(NSString*)  title WithContent:(NSString*) content WithPhotoName:(NSString*)photoName WithType:(NSString*)type WithBeginDate:(NSString*)beginDate AndEndDate:(NSString*)endDate
{
    if (!itemId || !type) {
        return NO;
    }
    
    Infos* infosObject = [self getInfosByItemId:itemId AndType:type];
    
    if (infosObject == nil) {
        infosObject = [NSEntityDescription insertNewObjectForEntityForName:@"Infos" inManagedObjectContext:[_appDelegate managedObjectContext]];
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
                                        inManagedObjectContext:_appDelegate.managedObjectContext];
    [fetchRequest setEntity:baiKeEntity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"itemId == %@ && type = %@", itemId, type];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
        
    }
    
    if (array && [array count] > 0) {
        [_appDelegate.managedObjectContext deleteObject:[array objectAtIndex:0]];
    }
    
    return YES;
}









-(Infos*)getInfosByItemId:(NSNumber*)itemId AndType:(NSString*)type
{
    Infos* InfosObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* baiKeEntity = [NSEntityDescription
                                        entityForName:@"Infos"
                                        inManagedObjectContext:_appDelegate.managedObjectContext];
    [fetchRequest setEntity:baiKeEntity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"itemId == %@ && type = %@", itemId, type];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
        
    }
    
    if (array && [array count] > 0) {
        InfosObject = [array objectAtIndex:0];
    }
    
    return InfosObject;
}



// 隱藏 status bar
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) backTabBarController
{
   
    UIStoryboard *storyboard;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
     NSString *controllerId= @"TabBar";
    UITabBarController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    // 使用 animated:YES 會出現 unbalanced calls to begin/end appearance transitions 的警告訊息，
    // 原因是上一個UIViewController的動畫沒做完，導致下一個頁面無法順利壓棧
    
    [initViewController setSelectedIndex:4];
    UIImage *navigationBar = [UIImage imageNamed:@"nva_bar"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBar forBarMetrics:UIBarMetricsDefault];
[self presentViewController:initViewController  animated:NO completion:nil];
//   [self.navigationController presentViewController:initViewController  animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
