//
//  QADetailViewController.m
//  Pregnancy
//
//  Created by giming on 2014/3/6.
//  Copyright (c) 2014年 giming. All rights reserved.
//

#import "QADetailViewController.h"

@interface QADetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel* contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation QADetailViewController

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
	
    // 改變 navigation title && leftBarButton 的設置
    self.navigationItem.title = _navigationTitle;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"";
    backBarButtonItem.image = [UIImage imageNamed:@"nva_icon02.png"];
    backBarButtonItem.target = self;
    backBarButtonItem.action = @selector(back:);
    // 必須設leftBarButonItem, 不知為何設 backBarButtonItem 無效
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    
    
    
 
    
    

                                                                
    
    
    // 接收 MainViewController 傳過來的資料後將值指定給相對應的元件
    self.titleLabel.text = self.title;
    //self.contentLabel.text = self.content;
    //self.photoImageView.image = [UIImage imageNamed:self.photoname];
//    [self.photoImageView setImageWithURL:[NSURL URLWithString:self.photoURLString]
//                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.contentTextView.text = self.content;
    
    NSLog(@"contentTextView.height:%f",self.contentTextView.contentSize.height);
    
    // 依內容計算TextView 所需的 height, 並指定給 contentTextView和scrollView
    /*********重要:記得把View的use autoLayout關掉，才能生效***********/
    CGFloat textViewHeight = [self measureHeightOfUITextView:self.contentTextView];
    // iPhone 和 iPad的解析度不同需要個別處理
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // iPhone 大小的調整
        self.contentTextView.frame = CGRectMake(05, 60, 300, textViewHeight);
        self.scrollView.contentSize = CGSizeMake(320,textViewHeight+60);
    }
    else
    {
        // iPad 大小的調整
        self.contentTextView.frame = CGRectMake(15, 60, 740, textViewHeight);
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,textViewHeight+ 60);
    }
    // 設定 contentTextView 屬性
    // 不能捲動
    self.contentTextView.scrollEnabled = NO;
    // 不能編輯
    self.contentTextView.editable = NO;
    // 不允許各式連結
    self.contentTextView.dataDetectorTypes = UIDataDetectorTypeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 隱藏 status bar
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    //    if ([textView respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    //    {
    
    NSLog(@"TextView.height:%f",textView.contentSize.height);
    // 取得原本的大小
    CGRect frame = textView.bounds;
    
    
    NSString *textToMeasure = textView.text;
    
    
    // 設定分段的方式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
    // 寛度不變之下，計算所需的高度。
    CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    // 實際運作發現高度有誤差。所以多加了150
    CGFloat measuredHeight = ceilf(CGRectGetHeight(size)+150 );//+ topBottomPadding);
    
    
    NSLog(@"measuredHeight:%f",measuredHeight);
    return measuredHeight;
    
    
    //    }
    
    //    else
    //
    //    {
    //
    //        return textView.contentSize.height;
    //
    //    }
    
}

- (BOOL)snapshotViewAfterScreenUpdates
{
    return YES;
}

@end
