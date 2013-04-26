//
//  RichChatVC.h
//  richchatdemo
//
//  Created by jia wang on 3/7/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "NHPlayer.h"

#define DEBUG_MODE YES
//#define VIEW_WIDTH 320
//#define VIEW_HEIGHT 460
//左右边界的缩进距离
#define VIEW_INSET 10
//当条目类型为时间时，cell的高度
#define CELL_TYPE_TIME_HEIGHT 30
//每行绘制气泡的顶部留白高度，效果是行与行的间隔，ps:时间类型的行不设置顶部留白
#define CELLS_SEPERATE 10
//头像的宽和高
#define FACE_HEIGHT 40
//是否每行都显示时间
#define CONTENT_DATE_LABLE_IS_SHOW YES
//条目不为时间类型时，日期lable高度
#define CONTENT_DATE_LABLE_HEIGHT 20
//条目不为时间类型时，日期lable字体大小
#define CONTENT_DATE_LABLE_FONT_SIZE 12
//聊天记录的字体大小
#define CONTENT_FONT_SIZE 18
//对self来说是右边，对对方来说是左边
#define CONTENT_INSET_BIG 20
//与CONTENT_INSET_BIG相反
#define CONTENT_INSET_SMALL 15
//Mood返回的view在气泡中的顶，底部缩进
#define CONTENT_INSET_TOP 3
#define CONTENT_INSET_BOTTOM (CONTENT_INSET_TOP+3)
//预定义文本输入框单行高度
#define INPUT_SINGLE_LINE_HEIGHT 38 //60
//预定义文本输入框字体
#define INPUT_FONT_SIZE        18




typedef enum {
    ENUM_HISTORY_TYPE_TIME=1,
    ENUM_HISTORY_TYPE_TEXT=2,
    ENUM_HISTORY_TYPE_VOICE=3,
    ENUM_HISTORY_TYPE_IMAGE=4,
    ENUM_HISTORY_TYPE_VIDEO=5,
    ENUM_HISTORY_TYPE_LOCATION=6,
}ENUM_HISTORY_TYPE;

@interface RichChatItem : NSObject
@property(nonatomic,assign)ENUM_HISTORY_TYPE itemType;
@property(nonatomic,strong)id itemContent;
@property(nonatomic,assign)NSDate * itemTime;
@property(nonatomic,strong)NSString * itemSenderTitle;
@property(nonatomic,strong)UIImage * itemSenderFace;
@property(nonatomic,assign)BOOL itemSenderIsSelf;
@end


@protocol RichChatDelegate<NSObject>
@required
-(void)     richChatRequestToUpdateHistory;
-(NSInteger)richChatHistoryCount;
-(void)     richChatHistoryItem:(RichChatItem *)item AtIndex:(NSInteger)index;
-(void)     richChatRequestToSendMessage:(id)content type:(ENUM_HISTORY_TYPE)type;
@optional
//-(void)     richChatOnClickCell:(NSInteger)row type:(ENUM_HISTORY_TYPE *)pType data:(NSData**)pData;
@end

@interface RichChatVC : UIViewController<UITableViewDataSource
,UITableViewDelegate
,UITextViewDelegate
,NHPlayerDelegate
,HPGrowingTextViewDelegate>{

}
@property(nonatomic,assign) id<RichChatDelegate>  delegate;
-(void)reloadTableView;
@end
