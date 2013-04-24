//
//  RichChatVC.m
//  richchatdemo
//
//  Created by jia wang on 3/7/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import "RichChatVC.h"
#import "MoodFaceVC.h"

//富聊天条目的模型实现
@implementation RichChatItem
@synthesize itemType;
@synthesize itemSenderTitle;
@synthesize itemContent;
@synthesize itemSenderFace;
@synthesize itemTime;
@synthesize itemSenderIsSelf;
@end

//富聊天视图控制的私有成员变量
@interface RichChatVC ()<MoodFaceDelegate>{
    CGFloat _heightKeyboard;
    UITableView * _table;
    UIImageView * _ivBg;
    UITextField * _tfBg;
    HPGrowingTextView * _tvInput;
    UIButton * _btnVoice;
    UIButton * _btnFace;
    UIButton * _btnPlus;
    UIButton * _btnTalk;
    UIButton * _btnCancel;
    
    BOOL  _isPan;
    BOOL  _isShowMood;
}
@property(nonatomic,strong)MoodFaceVC * mood;
@end

//富聊天视图控制的实现
@implementation RichChatVC
@synthesize delegate=_delegate;
@synthesize mood=_mood;
//预定义行高 字体
#define VIEW_WIDTH 320
#define VIEW_HEIGHT 460
#define FACE_HEIGHT 40
#define ITEMS_SEPERATE 10
#define ITEM_FONT_SIZE 18
#define VIEW_INSET 10
#define SINGLE_LINE_HEIGHT 38 //60
#define FONT_SIZE        18
//#define SINGLE_LINE_HEIGHT 40 //64
//#define FONT_SIZE        20
//#define SINGLE_LINE_HEIGHT 43 //70
//#define FONT_SIZE        22
//#define SINGLE_LINE_HEIGHT 45 //74
//#define FONT_SIZE        24

-(void)dealloc{
    [_mood release];
    [super dealloc];
}
-(void)loadView{
    UIView * view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, VIEW_WIDTH, self.navigationController.navigationBarHidden?VIEW_HEIGHT:(VIEW_HEIGHT-self.navigationController.navigationBar.frame.size.height));
    self.view=view;
    [view release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
        
    
   
    
    
    //聊天记录
    UITableView * table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    table.dataSource=self;
    table.delegate=self;
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    table.backgroundColor=[UIColor clearColor];
    [self.view addSubview:table];
    _table = table;
    [table release];
    
    //输入区域
    UIImageView * ivBg=[[UIImageView alloc]initWithImage:nil];
    ivBg.userInteractionEnabled=YES;
    ivBg.backgroundColor=[UIColor lightGrayColor];
    ivBg.frame=CGRectMake(0, 0, self.view.frame.size.width, SINGLE_LINE_HEIGHT+10);
    _ivBg=ivBg;
    [self.view addSubview:ivBg];
    [ivBg release];
    
    //+按钮
    UIButton * btnPlus=[UIButton buttonWithType:UIButtonTypeCustom];
    btnPlus.frame=CGRectMake(0, _tvInput.frame.origin.y, SINGLE_LINE_HEIGHT, SINGLE_LINE_HEIGHT);
    [btnPlus setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
//    [btnPlus addTarget:self action:@selector(onClickSend:) forControlEvents:UIControlEventTouchUpInside];
    _btnPlus = btnPlus;
    [ivBg addSubview:btnPlus];
    
    //表情按钮
    UIButton * btnFace=[UIButton buttonWithType:UIButtonTypeCustom];
    btnFace.frame=CGRectMake(SINGLE_LINE_HEIGHT, _tvInput.frame.origin.y, SINGLE_LINE_HEIGHT, SINGLE_LINE_HEIGHT);
    [btnFace setBackgroundImage:[UIImage imageNamed:@"happy"] forState:UIControlStateNormal];
    [btnFace addTarget:self action:@selector(onClickFace:) forControlEvents:UIControlEventTouchUpInside];
    _btnFace = btnFace;
    [ivBg addSubview:btnFace];
    
    //文字框背景
    UITextField * tf=[[UITextField alloc]init];
    tf.frame=CGRectMake(SINGLE_LINE_HEIGHT*2, 5, ivBg.frame.size.width-SINGLE_LINE_HEIGHT*3, SINGLE_LINE_HEIGHT);
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    tf.userInteractionEnabled=NO;
    [ivBg addSubview:tf];
    _tfBg=tf;
//    _tfBg.hidden=YES;
    [tf release];
    
    //文字框
    HPGrowingTextView * tv=[[HPGrowingTextView alloc]init];
    tv.font=[UIFont systemFontOfSize:FONT_SIZE];
    tv.delegate=self;
    tv.internalTextView.backgroundColor=[UIColor clearColor];
    tv.frame=tf.frame;
//    tv.keyboardType=UIKeyboardTypeDefault;
    tv.returnKeyType=UIReturnKeySend;
    tv.contentMode=UIControlContentVerticalAlignmentBottom;
    [ivBg addSubview:tv];
    _tvInput=tv;
    [tv release];
    
    //voice/text按钮
    UIButton * btnVoice=[UIButton buttonWithType:UIButtonTypeCustom];
    btnVoice.frame=CGRectMake(ivBg.frame.size.width-SINGLE_LINE_HEIGHT, _tvInput.frame.origin.y, SINGLE_LINE_HEIGHT, SINGLE_LINE_HEIGHT);
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:[UIImage imageNamed:@"text"] forState:UIControlStateSelected];
    [btnVoice addTarget:self action:@selector(onClickBtnVoiceText:) forControlEvents:UIControlEventTouchUpInside];
    _btnVoice = btnVoice;
    [ivBg addSubview:btnVoice];
    
    //Hold to talk
    UIButton * btnTalk=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * img = [UIImage imageNamed:@"holdtotalk"];
    btnTalk.frame=CGRectMake(ivBg.frame.size.width/2-img.size.width/2, 5, img.size.width, SINGLE_LINE_HEIGHT);
    [btnTalk setBackgroundImage:img forState:UIControlStateNormal];
    [btnTalk setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btnTalk setTitle:NSLocalizedString(@"Hold To Talk", nil) forState:UIControlStateNormal];
    _btnTalk=btnTalk;
    btnTalk.hidden=YES;
    [ivBg addSubview:btnTalk];
    [btnTalk addTarget:self action:@selector(onTalkTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnTalk addTarget:self action:@selector(onTalkTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    //move up to cancel
    UIButton * lab=[UIButton buttonWithType:UIButtonTypeCustom];
    lab.frame=CGRectMake(0, 0, 100, 100);
    lab.center=self.view.center;
    lab.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [lab setTitle:NSLocalizedString(@"Move Up To Cancel", nil) forState:UIControlStateNormal];
    [lab setTitle:NSLocalizedString(@"Release To Cancel", nil) forState:UIControlStateSelected];
    [self.view addSubview:lab];
    _btnCancel=lab;
    _btnCancel.hidden=YES;

    //手势
    UIPanGestureRecognizer * pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [_btnTalk addGestureRecognizer:pan];
//    lab.userInteractionEnabled=YES;
    [pan release];
    
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(richChatRequestToUpdateHistory)]) {
        [self.delegate richChatRequestToUpdateHistory];
    }
    
    MoodFaceVC * mvc=[[MoodFaceVC alloc]init];
    mvc.delegate=self;
    self.mood=mvc;
    CGRect rcMood = _mood.view.frame;
    rcMood.origin.y=_ivBg.frame.size.height+_ivBg.frame.origin.y;
    _mood.view.frame=rcMood;
    [self.view addSubview:mvc.view];
    [mvc release];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self autoMovekeyBoard:0 duration:0];
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    _heightKeyboard=keyboardRect.size.height;
    [self autoMovekeyBoard:keyboardRect.size.height duration:animationDuration];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (_isShowMood) {
        //把键盘撤掉就行了，就不把编辑区域整体下移了
    }else{
        [self autoMovekeyBoard:0 duration:animationDuration];
    }
    
}

-(void) autoMovekeyBoard: (float) h duration:(NSTimeInterval)time{
    
    [UIView animateWithDuration:time animations:^{
        _ivBg.frame= CGRectMake(_ivBg.frame.origin.x
                                 , (float)(self.view.frame.size.height-h-SINGLE_LINE_HEIGHT-10)
                                 , _ivBg.frame.size.width
                                 , SINGLE_LINE_HEIGHT+10);
        
        _tfBg.frame=CGRectMake(_tfBg.frame.origin.x, _tfBg.frame.origin.y, _tfBg.frame.size.width, SINGLE_LINE_HEIGHT);
        _tvInput.frame=_tfBg.frame;
        
        CGRect rc=_btnVoice.frame;
        rc.origin.y=_ivBg.frame.size.height-5-rc.size.height;
        _btnVoice.frame=rc;
        
        rc.size.width=SINGLE_LINE_HEIGHT;
        rc.origin.x=0;
        _btnPlus.frame=rc;
        
        rc.origin.x=SINGLE_LINE_HEIGHT;
        _btnFace.frame=rc;
        
        //通知栏20，导航栏44，编辑框SINGLE_LINE_HEIGHT
        _table.frame = CGRectMake(0.0f, 0.0f, VIEW_WIDTH,(float)(VIEW_HEIGHT-h-44-SINGLE_LINE_HEIGHT-10));
        CGRect rcMood = _mood.view.frame;
        rcMood.origin.y=_ivBg.frame.size.height+_ivBg.frame.origin.y;
        _mood.view.frame=rcMood;

        

    } completion:^(BOOL finished){
        if (finished) {
            [self moveTableViewToBottom];
        }
    }];
   
	    
    
    
}

#pragma mark - funtions
-(void)reloadTableView{
    [_table reloadData];
    [self moveTableViewToBottom];
}
-(void)onTalkTouchDown:(UIButton *)sender{
    _isPan=NO;
    _btnCancel.hidden=NO;
    NSLog(@"开始录音");
}
-(void)onTalkTouchUpInside:(UIButton *)sender{
    if (_isPan) {
        return;
    }
    _btnCancel.hidden=YES;
    NSLog(@"停止录音");
     [self sendMessage:@"一段语音"];
}
-(void)onClickBtnVoiceText:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (sender.selected) {
        //进入语音模式
//        [_tvInput setText:@""];
        [_tvInput resignFirstResponder];
        [self autoMovekeyBoard:0 duration:0.3];
    } else {
        //回到文字模式
        [_tvInput becomeFirstResponder];
    }
    _btnFace.hidden=sender.selected;
    _tfBg.hidden=sender.selected;
    _tvInput.hidden=sender.selected;
    _btnTalk.hidden=!sender.selected;
}
-(void)handlePanGesture:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan locationInView:self.view];
    BOOL isOnLab = CGRectContainsPoint(_btnCancel.frame, point);
    _btnCancel.selected=isOnLab;
    _isPan=YES;
    if (UIGestureRecognizerStateEnded==pan.state) {
        _btnCancel.hidden=YES;
        NSLog(@"停止录音");
        if (isOnLab) {
           
        } else {
            [self sendMessage:@"一段语音"];
        }
        
    }
    
    
}
-(void)onClickFace:(UIButton *)sender{
    _isShowMood=YES;
    if (_tvInput.internalTextView.isFirstResponder) {
        [_tvInput resignFirstResponder];
    }else{
        [self autoMovekeyBoard:216 duration:0.3];
    }
    
    
    
}
-(IBAction)onClickSend:(id)sender
{
	NSString *messageStr = _tvInput.text;
   
    
    if (messageStr == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败！" message:@"发送的内容不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else
    {
        RichChatItem * item=[[RichChatItem alloc]init];
        item.itemSenderTitle=messageStr;
        [self sendMessage:item];
        [item release];
    }
	_tvInput.text = @"";
	[_tvInput resignFirstResponder];
    
    
}
-(void)sendMessage:(RichChatItem*)item{
//    [_arrayHistory addObject:str];
//    [_table reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(richChatRequestToSendMessage:)]) {
        [self.delegate richChatRequestToSendMessage:item];
    }
    
}
#pragma mark - table

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RichChatItem * item=[[RichChatItem alloc]init];
    if (self.delegate && [self.delegate respondsToSelector:@selector(richChatHistoryItem:AtIndex:)]) {
        [self.delegate richChatHistoryItem:item AtIndex:indexPath.row];
    }
    CGFloat cellHeight=0;
    cellHeight=FACE_HEIGHT;
    if (item.itemType==ENUM_HISTORY_TYPE_TEXT) {
        NSString * strContent=item.itemContent;
        CGSize size=[strContent sizeWithFont:[UIFont systemFontOfSize:ITEM_FONT_SIZE] constrainedToSize:CGSizeMake(_table.frame.size.width-VIEW_INSET*2-FACE_HEIGHT-VIEW_INSET*2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
       
        if ((size.height+VIEW_INSET*2)>cellHeight) {
            cellHeight=size.height+VIEW_INSET*2;
        }
        
    }
    
    [item release];
    return cellHeight+ITEMS_SEPERATE;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentify=@"historyCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    RichChatItem * item=[[RichChatItem alloc]init];
    if (self.delegate && [self.delegate respondsToSelector:@selector(richChatHistoryItem:AtIndex:)]) {
        [self.delegate richChatHistoryItem:item AtIndex:indexPath.row];
    }
    //是一条信息
    if (item.itemType&&(item.itemType!=ENUM_HISTORY_TYPE_TIME)) {
        //只要是信息，就一定有头像
        UIImageView * ivFace=[[UIImageView alloc]init];
        if (item.itemSenderFace && [item.itemSenderFace isKindOfClass:[UIImage class]]) {
            ivFace.image=item.itemSenderFace;
        }
        CGRect rc=CGRectMake(item.itemSenderIsSelf?(_table.frame.size.width-VIEW_INSET-FACE_HEIGHT):VIEW_INSET, [self tableView:tableView heightForRowAtIndexPath:indexPath]-FACE_HEIGHT, FACE_HEIGHT, FACE_HEIGHT);
        ivFace.frame=rc;
        [cell.contentView addSubview:ivFace];
        [ivFace release];
        
        if (item.itemType==ENUM_HISTORY_TYPE_TEXT) {
            NSString * strContent=item.itemContent;
            CGSize size=[strContent sizeWithFont:[UIFont systemFontOfSize:ITEM_FONT_SIZE] constrainedToSize:CGSizeMake(_table.frame.size.width-VIEW_INSET*2-FACE_HEIGHT-VIEW_INSET*2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect rcContentBg=CGRectMake(item.itemSenderIsSelf
                                        ?VIEW_INSET
                                        :ivFace.frame.origin.x
                                        +ivFace.frame.size.width
                                        , ITEMS_SEPERATE
                                        , _table.frame.size.width-VIEW_INSET*2-FACE_HEIGHT
                                        , size.height+VIEW_INSET*2);
            
            UIImage * imgContentBg=[[UIImage imageNamed:(item.itemSenderIsSelf?@"bubbleSelf":@"bubble")]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
            UIImageView * ivContentBg=[[UIImageView alloc]init];
            ivContentBg.frame=rcContentBg;
            ivContentBg.image=imgContentBg;
            [cell.contentView addSubview:ivContentBg];
            [ivContentBg release];
            
            UILabel * lbContent=[[UILabel alloc]init];
            lbContent.frame=CGRectMake(VIEW_INSET, VIEW_INSET, size.width, size.height);
            lbContent.text=strContent;
            lbContent.font=[UIFont systemFontOfSize:FONT_SIZE];
            lbContent.numberOfLines=0;
            lbContent.lineBreakMode=NSLineBreakByWordWrapping;
            lbContent.backgroundColor=[UIColor clearColor];
            [ivContentBg addSubview:lbContent];
            [lbContent release];
            
        }

    }else{
        //不是信息，是时间标签
    }
          
    [item release];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(richChatHistoryCount)]) {
        return [self.delegate richChatHistoryCount];
    }else
        return 0;
}
-(void)moveTableViewToBottom{
    NSInteger rowsCount=[_table numberOfRowsInSection:0];
    if (rowsCount>0) {
        NSIndexPath * pi=[NSIndexPath indexPathForRow:rowsCount-1 inSection:0];
        [_table scrollToRowAtIndexPath:pi atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}
#pragma mark - hptext delegate
-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
   
    _tfBg.frame=CGRectMake(_tfBg.frame.origin.x, _tfBg.frame.origin.y, _tfBg.frame.size.width, height);
    _tvInput.frame=_tfBg.frame;
    
    CGRect rc=_ivBg.frame;
    rc.size.height=height+10;
    rc.origin.y=self.view.frame.size.height-_heightKeyboard-rc.size.height;
    _ivBg.frame=rc;
    
    rc=_btnPlus.frame;
    rc.origin.y=_ivBg.frame.size.height-5-rc.size.height;
    _btnPlus.frame=rc;
    
    rc=_btnFace.frame;
    rc.origin.y=_ivBg.frame.size.height-5-rc.size.height;
    _btnFace.frame=rc;
    
    rc=_btnVoice.frame;
    rc.origin.y=_ivBg.frame.size.height-5-rc.size.height;
    _btnVoice.frame=rc;
    
    _table.frame = CGRectMake(0.0f, 0.0f, VIEW_WIDTH,_ivBg.frame.origin.y);
    
    CGRect rcMood = _mood.view.frame;
    rcMood.origin.y=_ivBg.frame.size.height+_ivBg.frame.origin.y;
    _mood.view.frame=rcMood;

    [self moveTableViewToBottom];
}
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
        //return key
        [self onClickSend:nil];
        return NO;
}
#pragma mark - mood face delegate
-(void)moodFaceVC:(MoodFaceVC *)vc selected:(NSString *)strDescription imageName:(NSString *)strImg{
    [_tvInput setText:[_tvInput.text stringByAppendingString:strDescription]];
}
@end
