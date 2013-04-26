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
    UIButton * _btnCellVoice;
    
    BOOL  _isPan;
    BOOL  _isShowMood;
}
@property(nonatomic,strong)MoodFaceVC * mood;
@property(nonatomic,strong)NHPlayer * media;
@end

//富聊天视图控制的实现
@implementation RichChatVC
@synthesize delegate=_delegate;
@synthesize mood=_mood;
@synthesize media=_media;


//#define INPUT_SINGLE_LINE_HEIGHT 40 //64
//#define INPUT_FONT_SIZE        20
//#define INPUT_SINGLE_LINE_HEIGHT 43 //70
//#define INPUT_FONT_SIZE        22
//#define INPUT_SINGLE_LINE_HEIGHT 45 //74
//#define INPUT_FONT_SIZE        24

-(void)dealloc{
    _media.delegate=nil;
    [_media release];
    [_mood release];
    [super dealloc];
}
-(void)loadView{
    UIView * view=[[UIView alloc]init];
    CGRect  bounds=[[UIScreen mainScreen]applicationFrame];
    view.frame=CGRectMake(0, 0, bounds.size.width, self.navigationController.navigationBarHidden?bounds.size.height:(bounds.size.height/*-self.navigationController.navigationBar.frame.size.height*/));
    self.view=view;
    bounds=self.view.frame;
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
    if (DEBUG_MODE) {
        table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        table.backgroundColor=[UIColor cyanColor];
    }else{
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        table.backgroundColor=[UIColor clearColor];
    }
    
    
    [self.view addSubview:table];
    _table = table;
    [table release];
    
    //输入区域
    UIImageView * ivBg=[[UIImageView alloc]initWithImage:nil];
    ivBg.userInteractionEnabled=YES;
    ivBg.backgroundColor=[UIColor lightGrayColor];
    ivBg.frame=CGRectMake(0, 0, self.view.frame.size.width, INPUT_SINGLE_LINE_HEIGHT+10);
    _ivBg=ivBg;
    [self.view addSubview:ivBg];
    [ivBg release];
    
    //+按钮
    UIImage * imgPlus=[UIImage imageNamed:@"plus"];
    UIButton * btnPlus=[UIButton buttonWithType:UIButtonTypeCustom];
    btnPlus.frame=CGRectMake(0, _tvInput.frame.origin.y, imgPlus.size.width, imgPlus.size.height);
    [btnPlus setBackgroundImage:imgPlus forState:UIControlStateNormal];
//    [btnPlus addTarget:self action:@selector(onClickSend:) forControlEvents:UIControlEventTouchUpInside];
    _btnPlus = btnPlus;
    [ivBg addSubview:btnPlus];
    
    //表情按钮
    UIImage * imgFace=[UIImage imageNamed:@"happy"];
    UIButton * btnFace=[UIButton buttonWithType:UIButtonTypeCustom];
    btnFace.frame=CGRectMake(INPUT_SINGLE_LINE_HEIGHT, _tvInput.frame.origin.y, imgFace.size.width,imgFace.size.height);
    [btnFace setBackgroundImage:imgFace forState:UIControlStateNormal];
    [btnFace addTarget:self action:@selector(onClickFace:) forControlEvents:UIControlEventTouchUpInside];
    _btnFace = btnFace;
    [ivBg addSubview:btnFace];
    
    //文字框背景
    UITextField * tf=[[UITextField alloc]init];
    tf.frame=CGRectMake(INPUT_SINGLE_LINE_HEIGHT*2, 5, ivBg.frame.size.width-INPUT_SINGLE_LINE_HEIGHT*3, INPUT_SINGLE_LINE_HEIGHT);
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    tf.userInteractionEnabled=NO;
    [ivBg addSubview:tf];
    _tfBg=tf;
//    _tfBg.hidden=YES;
    [tf release];
    
    //文字框
    HPGrowingTextView * tv=[[HPGrowingTextView alloc]init];
    tv.font=[UIFont systemFontOfSize:INPUT_FONT_SIZE];
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
    UIImage * imgVoice=[UIImage imageNamed:@"voice"];
    UIImage * imgText=[UIImage imageNamed:@"text"];
    UIButton * btnVoice=[UIButton buttonWithType:UIButtonTypeCustom];
    btnVoice.frame=CGRectMake(ivBg.frame.size.width-INPUT_SINGLE_LINE_HEIGHT, _tvInput.frame.origin.y, imgVoice.size.width,imgVoice.size.height);
    [btnVoice setBackgroundImage:imgVoice forState:UIControlStateNormal];
    [btnVoice setBackgroundImage:imgText forState:UIControlStateSelected];
    [btnVoice addTarget:self action:@selector(onClickBtnVoiceText:) forControlEvents:UIControlEventTouchUpInside];
    _btnVoice = btnVoice;
    [ivBg addSubview:btnVoice];
    
    //Hold to talk
    UIButton * btnTalk=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * img = [UIImage imageNamed:@"talk_blue"];
    btnTalk.frame=CGRectMake(btnPlus.frame.origin.x+btnPlus.frame.size.width
                             , ivBg.frame.size.height/2-img.size.height/2
                             ,btnVoice.frame.origin.x-btnPlus.frame.size.width-btnPlus.frame.origin.x
                             , img.size.height);
    [btnTalk setImage:img forState:UIControlStateNormal];
    if (DEBUG_MODE) {
        btnTalk.backgroundColor=[UIColor yellowColor];
    }
    [btnTalk setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
//    [btnTalk setTitle:NSLocalizedString(@"Hold To Talk", nil) forState:UIControlStateNormal];
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
    mvc.mNWith=self.view.frame.size.width-VIEW_INSET*2-FACE_HEIGHT-CONTENT_INSET_BIG-CONTENT_INSET_SMALL;
    mvc.mNWordSize=CONTENT_FONT_SIZE;
    mvc.mNImgSize=24;
    self.mood=mvc;
    CGRect rcMood = _mood.view.frame;
    rcMood.origin.y=_ivBg.frame.size.height+_ivBg.frame.origin.y;
    _mood.view.frame=rcMood;
    [self.view addSubview:mvc.view];
    [mvc release];
    
    NHPlayer * player=[[NHPlayer alloc]init];
    player.delegate=self;
    self.media=player;
    [player release];
    
    
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
                                 , (float)(self.view.frame.size.height-h-INPUT_SINGLE_LINE_HEIGHT-10)
                                 , _ivBg.frame.size.width
                                 , INPUT_SINGLE_LINE_HEIGHT+10);
        
        _tfBg.frame=CGRectMake(_tfBg.frame.origin.x, _tfBg.frame.origin.y, _tfBg.frame.size.width, INPUT_SINGLE_LINE_HEIGHT);
        _tvInput.frame=_tfBg.frame;
        
        CGRect rc=_btnVoice.frame;
        rc.origin.y=_ivBg.frame.size.height-5-rc.size.height;
        _btnVoice.frame=rc;
        
        rc.size.width=INPUT_SINGLE_LINE_HEIGHT;
        rc.origin.x=0;
        _btnPlus.frame=rc;
        
        rc.origin.x=INPUT_SINGLE_LINE_HEIGHT;
        _btnFace.frame=rc;
        
        //通知栏20，导航栏44，编辑框INPUT_SINGLE_LINE_HEIGHT
        _table.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,(float)(self.view.frame.size.height-h-INPUT_SINGLE_LINE_HEIGHT-10));
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
    
    NSString * strPath=[NSTemporaryDirectory() stringByAppendingPathComponent:[@"talk" stringByAppendingPathExtension:@"caf"]];
    [_media recordTo:strPath];
    NSLog(@"开始录音");
}
-(void)onTalkTouchUpInside:(UIButton *)sender{
    if (_isPan) {
        return;
    }
    _btnCancel.hidden=YES;
    NSLog(@"停止录音");
    NSURL * url = _media.audioRecorder.url;
    NSTimeInterval length=_media.audioRecorder.currentTime;
    [_media.audioRecorder stop];
    if (length>1) {
        //send
        
            [self sendMessage:[NSData dataWithContentsOfURL:url] type:ENUM_HISTORY_TYPE_VOICE];
        
    }else{
        //不够长
    }

//     [self sendMessage:@"一段语音"];
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
        NSURL * url = _media.audioRecorder.url;
        NSTimeInterval length=_media.audioRecorder.currentTime;
        [_media.audioRecorder stop];
        if (length>1) {
            //send
           [self sendMessage:[NSData dataWithContentsOfURL:url] type:ENUM_HISTORY_TYPE_VOICE];
        }else{
            //不够长
        }
    }
    
    
}
-(void)onClickFace:(UIButton *)sender{
   
    
    if (_tvInput.internalTextView.isFirstResponder) {
        _isShowMood=YES;
        [_tvInput resignFirstResponder];
    }else{
        if (_isShowMood) {
              [self autoMovekeyBoard:0 duration:0.3];
            _isShowMood=NO;
        } else {
            [self autoMovekeyBoard:216 duration:0.3];
             _isShowMood=YES;
        }
        
    }
    
    
    
}
-(IBAction)onClickSend:(id)sender
{
	NSString *messageStr = _tvInput.text;
   
    
    if (messageStr == nil || [[messageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"发送的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else
    {
        
        [self sendMessage:messageStr type:ENUM_HISTORY_TYPE_TEXT];
        
    }
	_tvInput.text = @"";
	[_tvInput resignFirstResponder];
    
    
}
-(void)onClickCellButton:(UIButton *)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(richChatHistoryItem:AtIndex:)])
    {
        RichChatItem * item=[[RichChatItem alloc]init];
        [self.delegate richChatHistoryItem:item AtIndex:sender.tag];
        if (ENUM_HISTORY_TYPE_VOICE==item.itemType) {
            sender.selected=!sender.selected;
            if (sender.selected) {
                _btnCellVoice=sender;
                [_media playFileOnline:item.itemContent];
            }else{
                [_media.audioPlayer stop];
            }
            
        }
        [item release];
    }
}
-(void)sendMessage:(id)content type:(ENUM_HISTORY_TYPE)type{
    _isShowMood=NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(richChatRequestToSendMessage:type:)]) {
        [self.delegate richChatRequestToSendMessage:content type:type];
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
    if (item.itemType==ENUM_HISTORY_TYPE_TIME) {
        cellHeight=CELL_TYPE_TIME_HEIGHT;
    }else{
        if (item.itemType==ENUM_HISTORY_TYPE_TEXT) {
            NSString * strContent=item.itemContent;
            CGSize size=[_mood assembleMessageAtIndex:strContent].frame.size;
            if ((size.height+CONTENT_INSET_TOP+CONTENT_INSET_BOTTOM)>cellHeight) {
                cellHeight=size.height+CONTENT_INSET_TOP+CONTENT_INSET_BOTTOM;
            }
        }
        cellHeight+=CELLS_SEPERATE;
        
        if (CONTENT_DATE_LABLE_IS_SHOW) {
            cellHeight+=CONTENT_DATE_LABLE_HEIGHT;
        }
    }

    [item release];
    return cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentify=@"historyCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
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
        CGRect rcFace=CGRectMake(item.itemSenderIsSelf?(_table.frame.size.width-VIEW_INSET-FACE_HEIGHT):VIEW_INSET, [self tableView:tableView heightForRowAtIndexPath:indexPath]-FACE_HEIGHT, FACE_HEIGHT, FACE_HEIGHT);
        if (CONTENT_DATE_LABLE_IS_SHOW) {
            rcFace.origin.y-=CONTENT_DATE_LABLE_HEIGHT;
        }
        ivFace.frame=rcFace;
        [cell.contentView addSubview:ivFace];
        [ivFace release];
        
        CGRect rcContentBg=CGRectZero;
        UIImage * imgContentBg=[[UIImage imageNamed:(item.itemSenderIsSelf?@"bubbleSelf":@"bubble")]stretchableImageWithLeftCapWidth:item.itemSenderIsSelf?CONTENT_INSET_SMALL:CONTENT_INSET_BIG topCapHeight:16];
        //44*31 image size
        UIImageView * ivContentBg=[[UIImageView alloc]init];
        ivContentBg.userInteractionEnabled=YES;
        ivContentBg.image=imgContentBg;
        [cell.contentView addSubview:ivContentBg];
        [ivContentBg release];

        if (item.itemType==ENUM_HISTORY_TYPE_TEXT)
        {
            NSString * strContent=item.itemContent;
            UIView * viewContent=[_mood assembleMessageAtIndex:strContent];
            CGSize sizeContent=viewContent.frame.size;
            if (sizeContent.height<27/*单行文字的高度*/) {
                sizeContent.height=27;
            }
                       
            rcContentBg=CGRectMake(item.itemSenderIsSelf
                                        ?ivFace.frame.origin.x-sizeContent.width-CONTENT_INSET_BIG-CONTENT_INSET_SMALL
                                        :ivFace.frame.origin.x
                                        +ivFace.frame.size.width
                                        , CELLS_SEPERATE
                                        , sizeContent.width+CONTENT_INSET_BIG+CONTENT_INSET_SMALL
                                        , sizeContent.height+CONTENT_INSET_TOP+CONTENT_INSET_BOTTOM);                
            CGRect rcContent=viewContent.frame;
            rcContent.origin.x=item.itemSenderIsSelf?CONTENT_INSET_SMALL:CONTENT_INSET_BIG;
            rcContent.origin.y=CONTENT_INSET_TOP;
            viewContent.frame=rcContent;
            if (DEBUG_MODE) {
                viewContent.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
            }
            
            [ivContentBg addSubview:viewContent];
        }
        if (item.itemType==ENUM_HISTORY_TYPE_VOICE) {
            NSTimeInterval length=0;
            UIImage * imgPlay=[UIImage imageNamed:@"button_play"];
            CGSize sizeContent=CGSizeMake(length*2+imgPlay.size.width, imgPlay.size.height);
            if (sizeContent.height<27/*单行文字的高度*/) {
                sizeContent.height=27;
            }
            rcContentBg=CGRectMake(item.itemSenderIsSelf
                                   ?ivFace.frame.origin.x-sizeContent.width-CONTENT_INSET_BIG-CONTENT_INSET_SMALL
                                   :ivFace.frame.origin.x
                                   +ivFace.frame.size.width
                                   , CELLS_SEPERATE
                                   , sizeContent.width+CONTENT_INSET_BIG+CONTENT_INSET_SMALL
                                   , sizeContent.height+CONTENT_INSET_TOP+CONTENT_INSET_BOTTOM);
       
            
            UIButton * btnMsgVoice=[UIButton buttonWithType:UIButtonTypeCustom];
            [btnMsgVoice addTarget:self action:@selector(onClickCellButton:) forControlEvents:UIControlEventTouchUpInside];
            btnMsgVoice.tag=indexPath.row;
            [btnMsgVoice setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
            [btnMsgVoice setImage:[UIImage imageNamed:@"button_stop"] forState:UIControlStateSelected];
            CGRect rcContent=CGRectMake(0, 0, sizeContent.width, sizeContent.height);
            rcContent.origin.x=item.itemSenderIsSelf?CONTENT_INSET_SMALL:CONTENT_INSET_BIG;
            rcContent.origin.y=CONTENT_INSET_TOP;
            btnMsgVoice.frame=rcContent;
            if (DEBUG_MODE) {
                [btnMsgVoice setBackgroundColor:[UIColor yellowColor]];
            }
            
            [ivContentBg addSubview:btnMsgVoice];

        }
        if (rcContentBg.size.height<FACE_HEIGHT) {
            //单行的时候，可以确保气泡下沿与头像下沿齐平
            rcContentBg.origin.y=CELLS_SEPERATE+FACE_HEIGHT-rcContentBg.size.height;
        }
        ivContentBg.frame=rcContentBg;
        if (CONTENT_DATE_LABLE_IS_SHOW)
        {
            UILabel * lbDate=[[UILabel alloc]init];
            if (DEBUG_MODE) {
                lbDate.backgroundColor=[UIColor brownColor];
            } else {
                lbDate.backgroundColor=[UIColor clearColor];
            }
            lbDate.font=[UIFont systemFontOfSize:CONTENT_DATE_LABLE_FONT_SIZE];
            NSDate * date=(NSDate *)item.itemTime;
            lbDate.text=[self caculateTime:[date timeIntervalSince1970]];
            lbDate.textAlignment=item.itemSenderIsSelf?UITextAlignmentRight:UITextAlignmentLeft;
            CGSize size=[lbDate.text sizeWithFont:lbDate.font];
            CGRect rc=CGRectMake(item.itemSenderIsSelf?(ivFace.frame.origin.x-size.width):(rcContentBg.size.width<size.width?(rcContentBg.origin.x+rcContentBg.origin.x):(rcContentBg.origin.x+rcContentBg.size.width-size.width)),
                                 rcContentBg.origin.y+rcContentBg.size.height
                                 , size.width
                                 , CONTENT_DATE_LABLE_HEIGHT);
            lbDate.frame=rc;
            [cell.contentView addSubview:lbDate];
            [lbDate release];
            
        }


    }else{
        //不是信息，是时间标签
        if (item.itemType==ENUM_HISTORY_TYPE_TIME) {
            UILabel * lbDate=[[UILabel alloc]init];
            if (DEBUG_MODE) {
                lbDate.backgroundColor=[UIColor greenColor];
            } else {
                lbDate.backgroundColor=[UIColor clearColor];
            }
            CGRect rc=CGRectMake(0, 0, _table.frame.size.width, CELL_TYPE_TIME_HEIGHT);
            lbDate.frame=rc;
            NSDate * date=(NSDate *)item.itemContent;
            lbDate.text=[self caculateTime:[date timeIntervalSince1970]];
            lbDate.textAlignment=UITextAlignmentCenter;
            [cell.contentView addSubview:lbDate];
            [lbDate release];
        }
        
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
    
    _table.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width,_ivBg.frame.origin.y);
    
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
#pragma mark - nhplayer delegate
-(void)NHPlayer:(NHPlayer *)player onProgress:(CGFloat)progress{
    if (1==progress) {
        _btnCellVoice.selected=NO;
    }
}
#pragma mark - common
- (NSString *)caculateTime:(double)aDInterval
{
    NSString *aTimeString=@"";
    NSTimeInterval aLate = aDInterval;
    
    NSDate* aDateNow= [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval aIntervalNow=[aDateNow timeIntervalSince1970]*1;
    
    NSTimeInterval aDifferenceValue = aIntervalNow-aLate;
    
    if (aDifferenceValue / 3600 < 1) {
        aTimeString = [NSString stringWithFormat:@"%f", aDifferenceValue/60];
        aTimeString = [aTimeString substringToIndex:aTimeString.length-7];
        
        NSInteger aInt = [aTimeString intValue];
        aTimeString=[NSString stringWithFormat:NSLocalizedString(@"%d分钟前",@""), aInt];
        
    }
    if (aDifferenceValue / 3600 > 1 && aDifferenceValue / 86400 < 1) {
        aTimeString = [NSString stringWithFormat:@"%f", aDifferenceValue/3600];
        aTimeString = [aTimeString substringToIndex:aTimeString.length-7];
        aTimeString=[NSString stringWithFormat:NSLocalizedString(@"%@小时前",@""), aTimeString];
    }
    if (aDifferenceValue/86400>1&&aDifferenceValue/86400<3)
    {
        aTimeString = [NSString stringWithFormat:@"%f", aDifferenceValue/86400];
        aTimeString = [aTimeString substringToIndex:aTimeString.length-7];
        aTimeString=[NSString stringWithFormat:NSLocalizedString(@"%@天前",@""), aTimeString];
    }
    if (aDifferenceValue/86400>3) {
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        //[date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [date setDateFormat:@"MM-dd HH:mm:ss"];
        
        NSTimeInterval aLateInterval = aLate - aIntervalNow;
        
        NSDate *aDateFull = [NSDate dateWithTimeIntervalSinceNow:aLateInterval];
        aTimeString = [date stringFromDate:aDateFull];
        [date release];
    }
    
    return aTimeString;
}

@end
