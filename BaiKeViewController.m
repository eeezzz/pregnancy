//
//  BaiKeViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/1.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "BaiKeViewController.h"
#import "BaiKeCell.h"
//#import "BaiKeEntity.h"
#import "UpdateEntity.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"

#import "BaiKe.h"
#import "AppDelegate.h"
#import "Infos.h"

#import "IIViewDeckController.h"
#import "settingViewController.h"

#import "UpdateViewController.h"

@interface BaiKeViewController ()

@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSArray* CellItems;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;




@end

@implementation BaiKeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
//      UIImage *navigationBar = [UIImage imageNamed:@"nva_bar"];
//     [[UINavigationBar appearance] setBackgroundImage:navigationBar forBarMetrics:UIBarMetricsDefault];
    // iOS7 在需要改變樣式或隱藏狀態時調用
    // 在此調用是從UpdateViewController的 status 隱藏改變到目前的viewController status 顯示的改變
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(1, 2);
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0],
                                             NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:25.0],
                                                                      NSShadowAttributeName : shadow
                                                                      }];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0]];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStyleBordered target:self.viewDeckController action:@selector(toggleLeftView)];
    
    self.navigationItem.title = @"孕期百科";

   
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
//    return UIStatusBarStyleDefault;
    return UIStatusBarStyleLightContent;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 取得應用程式的代理物件參照
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    

    
    
  
   
    
    
    UIColor *color = [UIColor colorWithRed:235.0/255.0 green:55.0/255.0 blue:140.0/255.0 alpha:1.0];
        self.tabBarController.tabBar.tintColor = color;
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    //

//    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
//    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:nil];
//    [operationQueue addOperation:op];
    // 設置當使用者在TableView下拉時，呼叫 refresh 方法，進行網路資料的更新
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
    
                // 從資料庫讀取
            [self loadData];
    
    
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == \'BaiKe\'"];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    // 執行存取的指令並且將資料載入
    NSMutableArray* returnObjs = [[[_appDelegate managedObjectContext]
                                   executeFetchRequest:request error:&error] mutableCopy];
    
    // 將資料倒入表格的資料來源之中
    for (BaiKe *current in returnObjs) {
//        NSLog(@"current.baikeId->%@",current.baiKeId);
//        NSLog(@"current.title->%@", current.title);
//        NSLog(@"current.content->%@", current.content);
//        NSLog(@"current.photName->%@", current.photoName);
        [entityFound addObject:current];
        

    }
    
    // 將轉換的資料直接設給tableView所依賴的Array
    self.CellItems = entityFound;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
//-(void) refresh
//{
//    NSLog(@"refresh triggered");
//    // 執行 WebAPI 取得資料
//    [self getWithWebAPI];
//    // 將下拉元件的提示文字改為"刷新中"
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
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
    return [self.CellItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // 因為自定cell, 所以必須用自定的類別來初始, 程式才能對應到 Storeboard 的相關設定
    BaiKeCell* cell = (BaiKeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  // Configure the cell...
    
    UpdateEntity* entity = self.CellItems[indexPath.row];
    
    // 設定cell裡各自定欄位的顯示資料
    cell.titleLabel.text = entity.title;
    cell.contentLabel.text = entity.content;

    NSString *urlString = [NSString stringWithFormat:@"http://parent.kimy.com.tw/new/articleImgs/%@",entity.photoName];
    entity.photoURLString = urlString;
    NSLog(@"photoName : %@", entity.photoName);
    //cell.photoImageView.image = [UIImage imageNamed:baiKeEntity.photoName];
    //NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:urlString]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    



    return cell;
}

- (UIImage*)downloadImage:(NSURL*)url
{
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    return image;
    
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
        UpdateEntity* entity = self.CellItems[indexPath.row];
        
        DetailViewController* detailViewController = segue.destinationViewController;
        NSLog(@"%@",detailViewController);
        
//        detailViewController.title = @"Done!!";
        detailViewController.title = entity.title;
        detailViewController.content = entity.content;
        detailViewController.photoURLString = entity.photoURLString;
        detailViewController.navigationTitle = @"孕期百科";
        
    }
    else{
        NSLog(@"not next");
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"按下去的第%d個區塊，第%d筆資料", indexPath.section, indexPath.row);
//    BaiKeDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showDetail"];
//    detailViewController.titleLabel.text = @"YES";
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    
//}

@end
