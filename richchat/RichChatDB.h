//
//  RichChatDB.h
//  richchatdemo
//
//  Created by jia wang on 5/21/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

//need framework sqlite3.0.lib


#import <Foundation/Foundation.h>
#import "RichChatVC.h"
#import "FMDatabase.h"

@interface RichChatDB : NSObject{
    FMDatabase * _db;
}
-(void)insertItemWith:(NSString *)strUID time:(NSTimeInterval)time type:(ENUM_HISTORY_TYPE)type sender:(BOOL)isSelf content:(NSString *)content;
-(void)queryDialogWith:(NSString *)strUID toMutableArray:(NSMutableArray *)chatarray;
@end
