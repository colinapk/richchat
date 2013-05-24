//
//  RichChatDB.m
//  richchatdemo
//
//  Created by jia wang on 5/21/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import "RichChatDB.h"


#define DBNAME    @"richchat.sqlite"
#define KEY_UID      @"UID"
#define KEY_TIME       @"TIME"
#define KEY_TYPE   @"TYPE"
#define KEY_SENDER_IS_SELF @"SENDER_IS_SELF"
#define KEY_CONTENT @"CONTENT"

#define TABLENAME @"HISTORY"

@implementation RichChatDB
-(id)init{
    if (self=[super init]) {
        NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                    , NSUserDomainMask
                                                                    , YES);
        NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:DBNAME];
        _db=[[FMDatabase alloc]initWithPath:databaseFilePath];
        if ([_db open]) {
             NSString * strCreateTable=[NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,%@ text,%@ text,%@ integer,%@ bool,%@ text)",TABLENAME,KEY_UID,KEY_TIME,KEY_TYPE,KEY_SENDER_IS_SELF,KEY_CONTENT];
            [_db executeUpdate:strCreateTable];
            
        }
    }
    return self;
}
-(void)dealloc{
    [_db release];
    [super dealloc];
}

-(void)insertItemWith:(NSString *)strUID time:(NSTimeInterval)time type:(ENUM_HISTORY_TYPE)type sender:(BOOL)isSelf content:(NSString *)content{
    NSString * sql=[NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@) VALUES (?,?,?,?,?)"
                    ,TABLENAME
                    , KEY_UID, KEY_TIME, KEY_TYPE,KEY_SENDER_IS_SELF,KEY_CONTENT];
    
    
    
    [_db executeUpdate:sql, strUID  , [NSNumber numberWithDouble:time]  ,[NSNumber numberWithInteger:type] ,[NSNumber numberWithBool:isSelf] ,content];
}
-(void)queryDialogWith:(NSString *)strUID toMutableArray:(NSMutableArray *)chatarray{
    NSString * sql=[NSString stringWithFormat:@"SELECT %@,%@,%@,%@ FROM %@ WHERE %@ = ?",KEY_CONTENT,KEY_SENDER_IS_SELF,KEY_TIME,KEY_TYPE,TABLENAME,KEY_UID];
    FMResultSet *rs = [_db executeQuery:sql,strUID];
    while ([rs next]) {
        RichChatItem * item=[[RichChatItem alloc]init];
        item.itemContent=[rs stringForColumn:KEY_CONTENT];
        item.itemSenderIsSelf=[rs boolForColumn:KEY_SENDER_IS_SELF];
        item.itemTime=[NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:KEY_TIME]];
        item.itemType=[rs intForColumn:KEY_TYPE];
        item.itemSenderFace=[UIImage imageNamed:item.itemSenderIsSelf?@"wangjia":@"fugen"];
        
        [chatarray addObject:item];
        [item release];
    }
    [rs close];

}

@end
