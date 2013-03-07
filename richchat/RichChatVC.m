//
//  RichChatVC.m
//  richchatdemo
//
//  Created by jia wang on 3/7/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import "RichChatVC.h"

@interface RichChatVC (){
    
}
@property(nonatomic,strong)NSString * theOtherOne;
@end

@implementation RichChatVC
@synthesize theOtherOne=_theOtherOne;

- (id)initWithTheOtherOne:(NSString *)name
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.theOtherOne=name;
    }
    return self;
}
-(void)dealloc{
    [_theOtherOne release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=[NSString stringWithFormat:NSLocalizedString(@"Chating with %@", nil),_theOtherOne];
    
}



@end
