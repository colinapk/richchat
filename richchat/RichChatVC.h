//
//  RichChatVC.h
//  richchatdemo
//
//  Created by jia wang on 3/7/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichChatVC : UIViewController<UITableViewDataSource
,UITableViewDelegate
,UITextViewDelegate>{

}

-(id)initWithTheOtherOne:(NSString *)name;
@end
