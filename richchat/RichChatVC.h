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
    ENUM_HISTORY_TYPE_TEXT=1,
    ENUM_HISTORY_TYPE_VOICE=2,
    ENUM_HISTORY_TYPE_IMAGE=3,
    ENUM_HISTORY_TYPE_VIDEO,
    ENUM_HISTORY_TYPE_LOCATION,
}ENUM_HISTORY_TYPE;

@interface RichChatItem : NSObject
@property(nonatomic,assign)ENUM_HISTORY_TYPE itemType;
@property(nonatomic,strong)id itemContent;
@property(nonatomic,assign)NSTimeInterval itemTime;
@property(nonatomic,strong)NSString * itemSenderTitle;
@property(nonatomic,strong)UIImage * itemSenderFace;
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
