//
//  ZhouTiXingScrollViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/24.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "ZhouTiXingScrollViewController.h"
#import "AppDelegate.h"
#import "Infos.h"

@interface ZhouTiXingScrollViewController ()

@end

@implementation ZhouTiXingScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // 取得應用程式的代理物件參照
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    //      UIImage *navigationBar = [UIImage imageNamed:@"nva_bar"];
    //     [[UINavigationBar appearance] setBackgroundImage:navigationBar forBarMetrics:UIBarMetricsDefault];
    
    
    
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0]}];
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:230.0/255.0 green:56.0/255.0 blue:141.0/255.0 alpha:1.0]];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [super viewDidLoad];
//    
//    // 取得應用程式的代理物件參照
//    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
	// Do any additional setup after loading the view.
    // 預產期。需修改到資料庫中存取
    // 資料庫沒有預產期資料。須認證授權後
    [self setNeedsStatusBarAppearanceUpdate];
    // 將DeviceToken保存在NSUserDefaults
    
    NSString *estimate = [[NSUserDefaults standardUserDefaults] valueForKey:@"EstimatedDate"];
    NSLog(@"ZhouTiXingScrollViewController.viewWillAppear->estimate : %@", estimate);
    //    NSString *estimate = @"1900-01-01";
    
    
        NSDate* today = [NSDate date];
    
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* estimateDate = [dateFormatter dateFromString:estimate];
    
    int weeks;
    int calculateWeeks;
    
    // 沒有資料時要加的操作
    if (estimate == nil) {
//        NSString *controllerId =  @"ZhouTiXingNull" ;
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        
//        UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:controllerId];
//        //[self.navigationController pushViewController:initViewController animated:YES         ];
////        [self.navigationController presentViewController:initViewController animated:NO completion:nil];
//        [self addChildViewController:initViewController];
//        [self.view addSubview:initViewController.view];
        weeks = 0;
        calculateWeeks = 0;
        _weekLabel.text = [NSString stringWithFormat:@"預產期:[無預產期資料]"];
    }else
    {
    
    
        double interval = [estimateDate timeIntervalSinceDate:today];
        NSLog(@"timeInterval : %f", interval);

    calculateWeeks= (interval/60/60/24/7);
    if (calculateWeeks < 3) {
        weeks = 1;
         _weekLabel.text = [NSString stringWithFormat:@"預產期:%@, 目前第%d週",estimate, calculateWeeks];
    }
    if (calculateWeeks>43) {
        weeks = 44;
                _weekLabel.text = [NSString stringWithFormat:@"預產期:%@, 目前第%d週",estimate, calculateWeeks];
    }
    if (calculateWeeks>40 && calculateWeeks<=43) {
        weeks = calculateWeeks;
        _weekLabel.text = [NSString stringWithFormat:@"預產期:%@, 目前第%d週",estimate, weeks];
    }
    if (calculateWeeks>=3 && calculateWeeks<=40)
    {
        weeks = 40 - calculateWeeks;
        _weekLabel.text = [NSString stringWithFormat:@"預產期:%@, 目前第%d週",estimate, weeks];
        [self setupLocalNotifications:estimateDate AndWeeks:weeks];
    }
    
    }
    NSLog(@"calculateWeeks : %d",calculateWeeks);
    NSLog(@"weeks : %d", weeks);
    
    
//    _weekLabel.text = [NSString stringWithFormat:@"預產期:%@, 目前第%d週",estimate, weeks];
    _weekLabel.textColor = [UIColor blackColor];
    _weekLabel.numberOfLines = 0;
    
    NSString* imageNamed;
    
    if (weeks<3 || weeks>43) {
        imageNamed = [NSString stringWithFormat:@"weekbar_no"];
    }
    else
    {
        imageNamed = [NSString stringWithFormat:@"weekbar-%d",weeks];
    }
//    NSString* imageNamed = [NSString stringWithFormat:@"weekbar-%d",weeks];
    _weekImageView.image = [UIImage imageNamed:imageNamed];
    
    
    // UIPageControl設定
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 1;
    
    NSString* type = @"ZhouTiXing";
    NSMutableArray* titleArray = [[NSMutableArray alloc]init];
    NSMutableArray* contentArray = [[NSMutableArray alloc] init];
    NSNumber* itemId;
    Infos* infosObject;
    
    NSString* title = [NSString stringWithFormat:@"尚未授權或會員資料中並無預產期資料"];
    NSString* content = [NSString stringWithFormat:@"從懷孕初期開始，每週胎兒的成長都會不同，信誼奇蜜好孕生活館App將根據你每周的懷孕變化，個別推播叮嚀，讓你清楚知道每個月身心的改變跟寶寶的發展。\n\n建議點選左上角的設定按鍵進行認證與填寫寶寶預產期資料."];

    
    switch (weeks) {
        case 0:
            
            _pageControl.numberOfPages = 1;
            _pageControl.currentPage = 1;
            // 1
            itemId = [NSNumber numberWithInt:weeks];
            [titleArray addObject:title];
            [contentArray addObject:content];
            break;
            
        case 1 ... 2:
            _pageControl.numberOfPages = 1;
            _pageControl.currentPage = 1;
            // 1
            itemId = [NSNumber numberWithInt:weeks];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            break;
            
        case 3:
            _pageControl.numberOfPages = 2;
            _pageControl.currentPage = 0;
            // 取 3－4
            itemId = [NSNumber numberWithInt:weeks];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            
            itemId = [NSNumber numberWithInt:weeks+1];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            break;
        case 4 ... 42:
            _pageControl.numberOfPages = 3;
            _pageControl.currentPage = 1;
            // 取 weeks-1, weeks , weeks+1
            itemId = [NSNumber numberWithInt:weeks-1];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            
            itemId = [NSNumber numberWithInt:weeks];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            
            itemId = [NSNumber numberWithInt:weeks+1];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            break;
        case 43:
            _pageControl.numberOfPages = 2;
            _pageControl.currentPage = 1;
            // 取 39－40
            itemId = [NSNumber numberWithInt:weeks-1];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            
            itemId = [NSNumber numberWithInt:weeks];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            break;
        case 44:
            _pageControl.numberOfPages = 1;
            _pageControl.currentPage = 1;
            // 44
            itemId = [NSNumber numberWithInt:weeks];
            infosObject = [self getInfosByItemId:itemId AndType:type];
            [titleArray addObject:infosObject.title];
            [contentArray addObject:infosObject.content];
            break;
        default:
            _pageControl.numberOfPages = 0;
            [self alert];
            
            
            
           
  
            break;
            
 
    }
    

//    [titleArray addObject:@"妳可能還不知道自己懷孕了，且易發生自然流產現象"];
//    [titleArray addObject:@"受精卵已經順利著床，寶寶的主要器官開始慢慢成形了"];
//    [titleArray addObject:@"到醫療院所檢驗，確定自己已經懷孕及懷孕週數"];
//    
//    
//    [contentArray addObject:@ "恭喜妳！妳已經懷孕囉！不過，妳還不知道自己懷孕了，通常還要再等10天之後，才能用驗孕試紙測試出已經懷孕的結果。懷孕第三週是生命開始的一週，此時，精子和卵子在輸卵管相遇，結合成為受精卵之後，開始快速地進行細胞分裂，並且往子宮移動；到了懷孕的第三週末時，受精卵會到達子宮便埋入子宮內膜中（此過程稱為「著床」）。受精卵在著床的過程中，必須牢固地附著在子宮內膜上，新生命才算正式降臨，否則就會形成自然流產而排出體外，不過，此時發生的流產多是自然的篩選過程，準媽媽通常也不知道自己懷孕又流產了。"];
//    [contentArray addObject:@"如果妳有測量基礎體溫的習慣，就會發現自己在排卵期過後14天，基礎體溫仍持續37.5度的高溫，這就是妳已經懷孕的徵兆；不過，如果妳現在用一般的驗孕試紙驗孕，卻還不一定能驗出已經懷孕，可能還要再等幾天。而進入懷孕第四週，受精卵已經在妳的子宮裡順利著床，並且持續快速進行細胞分裂，進而發育成胚胎。到了懷孕第四週末時，雖然胚胎還不到1公釐的大小，但是寶寶的臉和四肢已經開始有些雛形，更重要的是，寶寶身體的主要器官已經開始慢慢成形了。"];
//    [contentArray addObject:@"如果妳「這個月剛好沒來」，而且最近經常覺得〝有尿意〞、〝反胃〞、〝乳房變得敏感、腫脹〞、〝容易疲倦〞、〝情緒化〞、〝便秘〞，或是〝突然喜歡或討厭某些味道〞等生理徵兆時，就有可能是懷孕囉。建議妳可以先到藥局購買驗孕試紙或驗孕棒，自己進行初步的驗孕，如果驗孕試紙呈現懷孕的反應，再盡快安排時間到婦產科作進一步的檢驗（通常是透過驗尿、驗血或是超音波檢查），確定自己已經懷孕及目前懷孕週數。如果妳選擇在全民健保特約的婦產科醫療院所進行驗孕的話，只要醫生確定妳懷孕之後，就可以領取孕婦健康手冊，正式升格成準媽媽囉！"];
    
    //UIScrollView設定
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    // 取得 scrollView 的原始大小，並將其 width 依所需頁數擴展
    CGFloat width, height;
    width = _scrollView.bounds.size.width;
    height = _scrollView.bounds.size.height;
    _scrollView.contentSize=CGSizeMake(width * _pageControl.numberOfPages, height);
    
//    NSMutableArray* titleArray = [[NSMutableArray alloc]init];
//    [titleArray addObject:@"妳可能還不知道自己懷孕了，且易發生自然流產現象"];
//    [titleArray addObject:@"受精卵已經順利著床，寶寶的主要器官開始慢慢成形了"];
//    [titleArray addObject:@"到醫療院所檢驗，確定自己已經懷孕及懷孕週數"];
//    
//    NSMutableArray* contentArray = [[NSMutableArray alloc] init];
//    [contentArray addObject:@ "恭喜妳！妳已經懷孕囉！不過，妳還不知道自己懷孕了，通常還要再等10天之後，才能用驗孕試紙測試出已經懷孕的結果。懷孕第三週是生命開始的一週，此時，精子和卵子在輸卵管相遇，結合成為受精卵之後，開始快速地進行細胞分裂，並且往子宮移動；到了懷孕的第三週末時，受精卵會到達子宮便埋入子宮內膜中（此過程稱為「著床」）。受精卵在著床的過程中，必須牢固地附著在子宮內膜上，新生命才算正式降臨，否則就會形成自然流產而排出體外，不過，此時發生的流產多是自然的篩選過程，準媽媽通常也不知道自己懷孕又流產了。"];
//    [contentArray addObject:@"如果妳有測量基礎體溫的習慣，就會發現自己在排卵期過後14天，基礎體溫仍持續37.5度的高溫，這就是妳已經懷孕的徵兆；不過，如果妳現在用一般的驗孕試紙驗孕，卻還不一定能驗出已經懷孕，可能還要再等幾天。而進入懷孕第四週，受精卵已經在妳的子宮裡順利著床，並且持續快速進行細胞分裂，進而發育成胚胎。到了懷孕第四週末時，雖然胚胎還不到1公釐的大小，但是寶寶的臉和四肢已經開始有些雛形，更重要的是，寶寶身體的主要器官已經開始慢慢成形了。"];
//    [contentArray addObject:@"如果妳「這個月剛好沒來」，而且最近經常覺得〝有尿意〞、〝反胃〞、〝乳房變得敏感、腫脹〞、〝容易疲倦〞、〝情緒化〞、〝便秘〞，或是〝突然喜歡或討厭某些味道〞等生理徵兆時，就有可能是懷孕囉。建議妳可以先到藥局購買驗孕試紙或驗孕棒，自己進行初步的驗孕，如果驗孕試紙呈現懷孕的反應，再盡快安排時間到婦產科作進一步的檢驗（通常是透過驗尿、驗血或是超音波檢查），確定自己已經懷孕及目前懷孕週數。如果妳選擇在全民健保特約的婦產科醫療院所進行驗孕的話，只要醫生確定妳懷孕之後，就可以領取孕婦健康手冊，正式升格成準媽媽囉！"];
    
    // 製作ScrollView 各頁的內容
    for (int i=0; i!=_pageControl.numberOfPages; i++) {
        CGRect pageFrame = CGRectMake(width*i, 0, width, height);
        UIView *view = [[UIView alloc]initWithFrame:pageFrame];
        
        //        CGFloat r, g ,b;
        //        r = (arc4random() % 10) / 10.0;
        //        g = (arc4random() % 10) / 10.0;
        //        b = (arc4random() % 10) / 10.0;
        //        [view setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:0.5]];
        
        
        //view.backgroundColor = [UIColor blackColor];
        view.backgroundColor = [UIColor whiteColor];
        
        //        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 55)];
        //        label.text = [NSString stringWithFormat:@"預產期:2014-06-08, 目前第0%d週",i+3];
        //        label.textColor = [UIColor whiteColor];
        //
        //        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 300, 55)];
        //        NSString* imageNamed = [NSString stringWithFormat:@"weekbar-0%d",i+3];
        //        imageView.image = [UIImage imageNamed:imageNamed];
        // iPhone 和 iPad的解析度不同需要個別處理
        
        UILabel* title;
        UITextView* content;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            // iPhone 大小的調整
            title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 55)];
            content = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 240)];
            title.font = [UIFont fontWithName:@"Helvetica" size:17.0];
            content.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        }
        else
        {
            // iPad 大小的調整
            title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 620, 110)];
            content = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, 620, 550)];
            title.font = [UIFont fontWithName:@"Helvetica" size:25.0];
            content.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        }
        
        
        
                title.text = [titleArray objectAtIndex:i];
        title.textColor = [UIColor blueColor];
        title.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:197.0/255.0 alpha:1.0];
        title.numberOfLines = 0;
        
        
        content.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:249.0/255.0 blue:197.0/255.0 alpha:1.0];
        content.text = [contentArray objectAtIndex:i];
        content.textColor = [UIColor blackColor];
        
        content.editable = NO;
//        [content.layer setCornerRadius:15.0];
        [view addSubview:content];
        [view addSubview:title];
        
        
        //        // create a page as a simple UILabel
        //        UILabel* pageLabel = [[UILabel alloc] initWithFrame:pageFrame] ;
        //        // set some label properties
        //
        //        [pageLabel setFont: [UIFont boldSystemFontOfSize: 200.0f]] ;
        //        [pageLabel setTextAlignment: NSTextAlignmentCenter] ;
        //        [pageLabel setTextColor: [UIColor darkTextColor]] ;
        //
        //        // set the label's text as the letter corresponding to the current page index
        //
        //        char aLetter = (char)((i+65)-(i/26)*26) ;
        //        [pageLabel setText: [NSString stringWithFormat: @"%c", aLetter]] ;
        
        //使用QuartzCore.framework替UIView加上圓角
        //[view.layer setCornerRadius:15.0];
        
        
        
        // add it to the scroll view
        
        //[_scrollView addSubview: pageLabel] ;
        
        [_scrollView addSubview:view];
        
    }
    [self changeCurrentPage:_pageControl];
    
    
    
    
}

-(void) alert
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"40週提醒"
                              message:@"無此週資料!!"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil,nil];
    [alertView show];
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

- (void)setupLocalNotifications:(NSDate*)estimateDate AndWeeks:(int)weeks
{
    // 將先前設定的取消
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone localTimeZone];
    // current time plus 10 secs
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //設定時間格式
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    NSDate *now = [NSDate date];
    
    NSDate *dateToFire=[estimateDate dateByAddingTimeInterval:-561600];
    
//    NSDate *dateToFire=[now dateByAddingTimeInterval:60];
    NSString* type = @"ZhouTiXing";

    NSNumber* itemId;
    Infos* infosObject;


        

    for (int i = 40 ; i>weeks; i--) {
        
        itemId = [NSNumber numberWithInt:i];
        infosObject = [self getInfosByItemId:itemId AndType:type];
        
        
        
        NSLog(@"now time: %@", [formatter stringFromDate:now]);
        NSLog(@"fire time: %@, title:%@", [formatter stringFromDate:dateToFire], infosObject.title);
        
        localNotification.fireDate = dateToFire;
        localNotification.alertBody = infosObject.title;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1; // increment
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
        localNotification.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        dateToFire = [dateToFire dateByAddingTimeInterval:-604800];
//        dateToFire = [dateToFire dateByAddingTimeInterval:60];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    // 計算目前位置在第幾頁
    NSInteger currentPage = (scrollView.contentOffset.x + (width/2)) /width ;
    _pageControl.currentPage = currentPage;
}

- (IBAction)changeCurrentPage:(UIPageControl *)sender
{
    NSInteger page = _pageControl.currentPage;
    
    CGFloat width, height;
    width = _scrollView.frame.size.width;
    height = _scrollView.frame.size.height;
    CGRect frame = CGRectMake(width*page, 0, width, height);
    
    [_scrollView scrollRectToVisible:frame animated:YES];
}
@end
