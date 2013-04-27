//
//  MainViewController.m
//  richchatdemo
//
//  Created by jia wang on 4/22/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import "MainViewController.h"
#import "NHPlayer.h"
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
        [vc reloadTableViewToTop:NO];
    }
    
}
#pragma mark - rich chat delegate
-(void)richChatRequestToUpdateHistory{
    //模仿网络请求
    NSString * path=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"demoHistory.plist"];
    NSArray * items=[[NSArray alloc]initWithContentsOfFile:path];
    NSDictionary * dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"200",@"code",items,@"data",nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestSucceed:) userInfo:dict repeats:NO];
    
    [dict release];
    [items release];
    
    
}
-(void)richChatRequestToLoadMore{
    
}

-(void)richChatRequestToSendMessage:(id)content type:(ENUM_HISTORY_TYPE)type{
//    item.itemSenderTitle=[dict objectForKey:@"sender_title"];
//    item.itemType=(ENUM_HISTORY_TYPE)[[dict objectForKey:@"type"]integerValue];
//    item.itemTime=[dict objectForKey:@"time"];
//    item.itemSenderFace=[UIImage imageNamed:[dict objectForKey:@"sender_face"]];
//    item.itemContent=[dict objectForKey:@"content"];
//    item.itemSenderIsSelf=[[dict objectForKey:@"sender_is_self"]boolValue];
    //模仿网络请求
    NSMutableDictionary * dictitem=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",type],@"type",@"wangjia",@"sender_title",[NSDate date],@"time" ,@"wangjia",@"sender_face",@"1",@"sender_is_self",nil];
    if (ENUM_HISTORY_TYPE_TEXT==type) {
        [dictitem setObject:content forKey:@"content"];
    }
    if (ENUM_HISTORY_TYPE_VOICE==type) {
//        NSData * data=(NSData *)content;
        //上传给服务器
        //成功后刷界面
        
        //刷界面得到的是一个网址，用户点击后下载播放
        [dictitem setObject:@"http://file.market.xiaomi.com/download/df7/a28e0bf3d7e7627ff2244c73d155588c388208b5/%E8%9C%A1%E7%AC%94%E5%B0%8F%E6%96%B0-%E8%80%81%E5%A4%A7%E5%8A%A0%E6%B2%B9.mp3" forKey:@"content"];
    }
   
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
//            item.itemSenderTitle=[dict objectForKey:@"sender_title"];
            item.itemType=(ENUM_HISTORY_TYPE)[[dict objectForKey:@"type"]integerValue];
            item.itemContent=[dict objectForKey:@"content"];
            item.itemTime=[dict objectForKey:@"time"];
            item.itemSenderFace=[UIImage imageNamed:[dict objectForKey:@"sender_face"]];
            item.itemSenderIsSelf=[[dict objectForKey:@"sender_is_self"]boolValue];
        }
    }
}

@end
