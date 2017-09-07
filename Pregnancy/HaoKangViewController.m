//
//  HaoKangViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/6.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "HaoKangViewController.h"
#import "BaiKeCell.h"
#import "BaiKeEntity.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Infos.h"
#import "AppDelegate.h"
#import "HaoKang.h"


@interface HaoKangViewController ()

@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSArray* BaiKes;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HaoKangViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    //      UIImage *navigationBar = [UIImage imageNamed:@"nva_bar"];
    //     [[UINavigationBar appearance] setBackgroundImage:navigationBar forBarMetrics:UIBarMetricsDefault];
    [self setNeedsStatusBarAppearanceUpdate];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0]}];
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0]];
    
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // 取得應用程式的代理物件參照
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 設置當使用者在TableView下拉時，呼叫 refresh 方法，進行網路資料的更新
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
    
    int try = 4;
    
    switch (try) {
        case 1:
            // 內建寫死資料
//            [self getWithNoneWebAPI];
            break;
        case 2:
            // 執行 WebAPI
//            [self getWithWebAPI];
            break;
        case 3:
            [self writeDb];
            break;
        case 4:
            // 從資料庫讀取
            [self loadData];
            break;
        default:
            // 內建寫死資料
//            [self getWithNoneWebAPI];
            break;
    }

}

-(void)loadData
{
    // 資料先清空
    NSMutableArray* entityFound = [[NSMutableArray alloc] init];
    
    
    // 從Core Data Framework 取出 Book Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Infos"
                                   inManagedObjectContext:[_appDelegate managedObjectContext]];
    
    [request setEntity:entity];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == \'HaoKang\' && beginDate <= \'2014-04-11\' && endDate >= \'2014-04-11\'"];
//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == \'HaoKang\' && beginDate <= \'2014-04-10\' "];
    [request setPredicate:predicate];
    NSError *error = nil;
    
    // 執行存取的指令並且將資料載入
    NSMutableArray* returnObjs = [[[_appDelegate managedObjectContext]
                                   executeFetchRequest:request error:&error] mutableCopy];
    
    // 將資料倒入表格的資料來源之中
    for (Infos *current in returnObjs) {
                NSLog(@"current.baikeId->%@",current.itemId);
                NSLog(@"current.title->%@", current.title);
                NSLog(@"current.content->%@", current.content);
                NSLog(@"current.photName->%@", current.photoName);
        NSLog(@"current.beginDate->%@", current.beginDate);
        NSLog(@"current.beginDate->%@", current.endDate);

        
//        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate* beginDate = [dateFormatter dateFromString:[current.beginDate substringToIndex:10]];
//        NSDate* endDate = [dateFormatter dateFromString:[current.endDate substringToIndex:10]];
//        NSDate *now = [NSDate date];
        
        
        
        
        [entityFound addObject:current];
        
        
    }
    
    // 將轉換的資料直接設給tableView所依賴的Array
    self.BaiKes = entityFound;
    
    [self.tableView reloadData];}


-(void)writeDb
{

    [self addHaoKangInHaoKangID:[NSNumber numberWithInt:111] WithTitle:@"title" WithContent:@"content" AndPhotoName:@"photoName"];
}


-(void)addHaoKangInHaoKangID:(NSNumber*)haoKangId WithTitle:(NSString*) title WithContent:(NSString*) content AndPhotoName:(NSString*) photoName
{
    HaoKang* haoKang = [NSEntityDescription insertNewObjectForEntityForName:@"HaoKang" inManagedObjectContext:[_appDelegate managedObjectContext]];
    
    haoKang.haoKangId = haoKangId;
    haoKang.title = title;
    haoKang.content = content;
    haoKang.photoName = photoName;
    
    // 準備將Entity存進Core Data
    NSError* error = nil;
    if (![_appDelegate.managedObjectContext save:&error]) {
        NSLog(@"新增資料發生錯誤");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) refresh
//{
//    NSLog(@"refresh triggered");
//    // 執行 WebAPI 取得資料
//    [self getWithWebAPI];
//    // 將下拉元件的提示文字改為"刷新中"
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
//}

//// 執行 WebAPI 取得資料
//- (void) getWithWebAPI
//{
//    // 設置 NSURLSessionConfiguration
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    // 以即有的 NSURLSessionConfiguration 設置 NSURLSession
//    _session =[NSURLSession sessionWithConfiguration:config];
//    // 設置 WebAPI 的 NSURL 給接續的 NSURLSessionDataTask 使用
//    NSString* urlStr = @"http://api.kimy.com.tw/Intra/api/PregnancyApp/HaoKang";
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    // 顯示網路儲存動態圖示
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    // WebAPI 呼叫
//    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //  沒有回應任何錯誤
//        if (!error) {
//            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*) response;
//            // 進行 statusCode:200 的處理
//            if (httpResp.statusCode == 200) {
//                NSError* jsonError;
//                // 將傳回JSON的資料，以 NSArray 儲存
//                // 以目前 WebAPI 的回傳內容，系統會以2維陣列來存放
//                // 1維儲存內容陣列，1維儲存內容
//                NSArray *BaiKeJSON = [NSJSONSerialization
//                                      JSONObjectWithData:data
//                                      options:NSJSONReadingAllowFragments
//                                      error:&jsonError];
//                if (!jsonError) {
//                    /* 開發測試用
//                     NSLog(@"BaiKeJSON : %@",BaiKeJSON);
//                     NSString* content = [[BaiKeJSON objectAtIndex:0] objectForKey:@"Content"];
//                     NSLog(@"text : %@", content);
//                     */
//                    
//                    // 以一個array存放傳回來的JSON轉換IOS能處理的資料
//                    NSMutableArray* entityFound = [[NSMutableArray alloc] init];
//                    
//                    for (NSDictionary *metadata in BaiKeJSON) {
//                        BaiKeEntity* entity = [[BaiKeEntity alloc] initWithJsonData:metadata];
//                        [self addHaoKangInHaoKangID:entity.BaiKeId WithTitle:entity.title WithContent:entity.content AndPhotoName:entity.photoName];
//                        [entityFound addObject:entity];
//                        
//                    }
//                    
//                    // 將轉換的資料直接設給tableView所依賴的Array
//                    self.BaiKes = entityFound;
//                    
//                    // 呼叫主線程來做畫面的更新
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // 關閉網路儲存動態圖示
//                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                        // 關閉下拉更新元件的動態圖示
//                        [self.refreshControl endRefreshing];
//                        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//                        // 重置TabView
//                        [self.tableView reloadData];
//                        
//                    });
//                }
//            }
//            else
//            {
//                // 關閉網路儲存動態圖示
//                
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                NSLog(@"http response error : %ld, %@,%@", (long)httpResp.statusCode, httpResp.description,httpResp.debugDescription);
//                
//                UIAlertView *alertView = [[UIAlertView alloc]
//                                          initWithTitle:@"Updating Error"
//                                          message:@"呼叫API時發生錯誤"
//                                          delegate:nil
//                                          cancelButtonTitle:@"知道了"
//                                          otherButtonTitles:nil];
//                [alertView show];
//                
//            }
//            
//        } else {
//            
//            NSLog(@"dataTask level error : %@", error.description);
//            // 回到主線程顯示錯誤訊息
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alertView = [[UIAlertView alloc]
//                                          initWithTitle:@"Updating Error"
//                                          message:[error.userInfo objectForKey:@"NSLocalizedDescription"]
//                                          delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//                [alertView show];
//            });
//        }
//        
//    }];
//    
//    // 啟動 NSURLSessionDataTask
//    [dataTask resume];
//    
//}
//
//// 測試用
//- (void) getWithNoneWebAPI
//{
//    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
//    
//    BaiKeEntity* baiKeEntity = [[BaiKeEntity alloc]init];
//    
//    
//    baiKeEntity = [[BaiKeEntity alloc]init];
//    baiKeEntity.title = @"親師溝通，縮短上學適應時間";
//    baiKeEntity.content = @"家中若有開始上學的孩子，成為小小新鮮人也過了一陣子，雖然從每天校門口的哭哭啼啼，已進階到能微笑說bye-bye，但熟悉自家幼兒種種習性和小脾氣的爸媽，心中仍難免有那麼一點不安。想要多瞭解孩子在學校的生活，面對語言表達尚不充分的孩子，又該怎麼做呢？";
//    baiKeEntity.photoName = @ "20130715153159";
//    [tempArray addObject:baiKeEntity];
//    
//    baiKeEntity = [[BaiKeEntity alloc]init];
//    
//    baiKeEntity.title = @"流感疫苗Q&A";
//    baiKeEntity.content = @"臺灣處於亞熱帶地區，雖然一年四季都有流感病例，但仍以秋、冬季較容易發生流行，流行高峰期多自12月至隔年1、2月，而10月正是病例數量開始上升的時刻，疾病管制署已經宣布公費流感疫苗自今年10月1日起開始免費施打。以下提供關於流感疫苗的Q&A給大家參考。";
//    
//    baiKeEntity.photoName = @ "20130701152237";
//    [tempArray addObject:baiKeEntity];
//    
//    baiKeEntity = [[BaiKeEntity alloc]init];
//    baiKeEntity.title = @"親師溝通，縮短上學適應時間";
//    baiKeEntity.content = @"家中若有開始上學的孩子，成為小小新鮮人也過了一陣子，雖然從每天校門口的哭哭啼啼，已進階到能微笑說bye-bye，但熟悉自家幼兒種種習性和小脾氣的爸媽，心中仍難免有那麼一點不安。想要多瞭解孩子在學校的生活，面對語言表達尚不充分的孩子，又該怎麼做呢？";
//    baiKeEntity.photoName = @ "20130715153159";
//    [tempArray addObject:baiKeEntity];
//    
//    self.BaiKes = tempArray;
//    
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.BaiKes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // 因為自定cell, 所以必須用自定的類別來初始, 程式才能對應到 Storeboard 的相關設定
    BaiKeCell* cell = (BaiKeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    BaiKeEntity* baiKeEntity = self.BaiKes[indexPath.row];
    
    // 設定cell裡各自定欄位的顯示資料
    cell.titleLabel.text = baiKeEntity.title;
    cell.contentLabel.text = baiKeEntity.content;
    
    NSLog(@"photoName : %@", baiKeEntity.photoName);
    
    NSString *urlString = [NSString stringWithFormat:@"http://photo.kimy.com.tw/PhotoManagement/NewsletterImage/%@",baiKeEntity.photoName];
    baiKeEntity.photoURLString = urlString;
    //cell.photoImageView.image = [UIImage imageNamed:baiKeEntity.photoName];
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:urlString]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}


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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 
 if ([[segue identifier] isEqualToString:@"next"]) {
 NSLog(@"goto next");
 NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
 BaiKeEntity* entity = self.BaiKes[indexPath.row];
 
 DetailViewController* detailViewController = segue.destinationViewController;
 NSLog(@"%@",detailViewController);
 
 //        detailViewController.title = @"Done!!";
 detailViewController.title = entity.title;
 detailViewController.content = entity.content;
     
 detailViewController.photoURLString = entity.photoURLString;
 detailViewController.navigationTitle = @"育兒好康"; }
 else{
 NSLog(@"not next");
 }
 }

@end
