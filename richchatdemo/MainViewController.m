//
//  MainViewController.m
//  richchatdemo
//
//  Created by jia wang on 4/22/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import "MainViewController.h"
@interface MainViewController ()
@property(nonatomic,retain)NSArray * chatArray;
@end

@implementation MainViewController
@synthesize chatArray=_chatArray;

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
	// Do any additional setup after loading the view.
    UIButton * btnChat=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnChat setTitle:@"Jim" forState:UIControlStateNormal];
    [btnChat addTarget:self action:@selector(onPressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    btnChat.frame=CGRectMake(0, 0, 200, 100);
    btnChat.center=self.view.center;
    [self.view addSubview:btnChat];
    
    NSArray * array=[[NSArray alloc]init];
    self.chatArray=array;
    [array release];
    
}
#pragma mark - funtions
-(void)onPressedBtn:(UIButton*)sender{
    RichChatVC * vc=[[RichChatVC alloc]init];
    vc.delegate=self;
    vc.title=sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
-(void)requestSucceed:(NSTimer *)timer{
    NSDictionary * userinfo=timer.userInfo;
    NSArray * data=[userinfo objectForKey:@"data"];
    if (data&&[data isKindOfClass:[NSArray class]]) {
        self.chatArray=data;
    }
    
    RichChatVC * vc=(RichChatVC *)self.navigationController.topViewController;
    if ([vc isKindOfClass:[RichChatVC class]]) {
        [vc reloadTableView];
    }
    
}
#pragma mark - rich chat delegate
-(void)richChatRequestToUpdateHistory{
    //模仿网络请求
    NSDictionary * item=[[NSDictionary alloc]initWithObjectsAndKeys:@"Jim",@"sender_title",nil];
    NSArray * items=[[NSArray alloc]initWithObjects:item,item, nil];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"200",@"code",items,@"data",nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestSucceed:) userInfo:dict repeats:NO];
    
    [dict release];
    [items release];
    [item release];
    
}
-(void)richChatRequestToSendMessage:(RichChatItem *)item{
    //模仿网络请求
    NSDictionary * dictitem=[[NSDictionary alloc]initWithObjectsAndKeys:item.itemSenderTitle,@"sender_title",nil];
    NSMutableArray * items=[[NSMutableArray alloc]initWithArray:self.chatArray];
    [items addObject:dictitem];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"200",@"code",items,@"data",nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestSucceed:) userInfo:dict repeats:NO];
    
    [dict release];
    [items release];
    [dictitem release];

}
-(NSInteger)richChatHistoryCount{
    return self.chatArray.count;
}
-(void)richChatHistoryItem:(RichChatItem *)item AtIndex:(NSInteger)index{
    if (index<self.chatArray.count) {
        NSDictionary * dict=[self.chatArray objectAtIndex:index];
        if (dict&&[dict isKindOfClass:[NSDictionary class]]) {
            //将dict中的数据赋值给对应的item属性
            item.itemSenderTitle=[dict objectForKey:@"sender_title"];
            item.itemType=ENUM_HISTORY_TYPE_TEXT;
            item.itemTime=[NSDate timeIntervalSinceReferenceDate];
            item.itemSenderFace=[UIImage imageNamed:@"wangjia"];
            item.itemContent=@"Hello!";
        }
    }
}
@end
