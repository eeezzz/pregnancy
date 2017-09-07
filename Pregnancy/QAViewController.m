//
//  QAViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/6.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "QAViewController.h"

#import "BaiKeCell.h"
//#import "BaiKeEntity.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UpdateEntity.h"

#import "BaiKe.h"
#import "AppDelegate.h"
#import "UpdateEntity.h"
#import "Infos.h"

@interface QAViewController ()

@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, strong) NSArray* CellItems;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QAViewController



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
    [self setNeedsStatusBarAppearanceUpdate];
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
    
//    int try = 2;
//    
//    switch (try) {
//        case 1:
//            // 內建寫死資料
//            [self getWithNoneWebAPI];
//            break;
//        case 2:
//            // 執行 WebAPI
//            [self getWithWebAPI];
//            break;
//        default:
//            // 內建寫死資料
//            [self getWithNoneWebAPI];
//            break;
//    }
    
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == \'QA\'"];
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
    
//    NSLog(@"photoName : %@", baiKeEntity.photoName);
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://photo.kimy.com.tw/PhotoManagement/NewsletterImage/%@",baiKeEntity.photoName];
//    baiKeEntity.photoURLString = urlString;
//    //cell.photoImageView.image = [UIImage imageNamed:baiKeEntity.photoName];
//    [cell.photoImageView setImageWithURL:[NSURL URLWithString:urlString]
//                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
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
     UpdateEntity* entity = self.CellItems[indexPath.row];
 
     DetailViewController* detailViewController = segue.destinationViewController;
     NSLog(@"%@",detailViewController);
 
 //        detailViewController.title = @"Done!!";
     detailViewController.title = entity.title;
     detailViewController.content = entity.content;
     detailViewController.photoURLString = entity.photoURLString;
     detailViewController.navigationTitle = @"熱門QA";
 }
 else{
     NSLog(@"not next");
    }
 }

@end
