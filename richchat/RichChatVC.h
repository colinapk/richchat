//
//  RichChatVC.h
//  richchatdemo
//
//  Created by jia wang on 3/7/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@class RichChatVC;

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
-(void)richChatRequestToUpdateHistory;
-(NSInteger)richChatHistoryCount;
-(void)richChatHistoryItem:(RichChatItem *)item AtIndex:(NSInteger)index;
-(void)richChatRequestToSendMessage:(RichChatItem *)item;
@end

@interface RichChatVC : UIViewController<UITableViewDataSource
,UITableViewDelegate
,UITextViewDelegate
,HPGrowingTextViewDelegate>{

}
@property(nonatomic,assign) id<RichChatDelegate>  delegate;
-(void)reloadTableView;
@end
