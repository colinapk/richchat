//
//  RichChatVC.m
//  richchatdemo
//
//  Created by jia wang on 3/7/13.
//  Copyright (c) 2013 Colin. All rights reserved.
//

#import "RichChatVC.h"

@interface RichChatVC (){
    CGFloat _heightKeyboard;
    UITableView * _table;
    UIImageView * _ivBg;
    UITextField * _tfBg;
    UITextView * _tvInput;
    UIButton * _btnVoice;
    UIButton * _btnFace;
    UIButton * _btnPlus;
    UIButton * _btnTalk;
    UIButton * _btnCancel;
    
    BOOL  _isPan;
}
@property(nonatomic,strong)NSString * theOtherOne;
@property(nonatomic,strong)NSMutableArray * arrayHistory;
@end

@implementation RichChatVC
@synthesize theOtherOne=_theOtherOne;
@synthesize arrayHistory=_arrayHistory;


#define SINGLE_LINE_HEIGHT 38 //60
#define FONT_SIZE        18
//#define SINGLE_LINE_HEIGHT 40 //64
//#define FONT_SIZE        20
//#define SINGLE_LINE_HEIGHT 43 //70
//#define FONT_SIZE        22
//#define SINGLE_LINE_HEIGHT 45 //74
//#define FONT_SIZE        24


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
    [_arrayHistory release];
    [_theOtherOne release];
    [super dealloc];
}
-(void)loadView{
    UIView * view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, 320, self.navigationController.navigationBarHidden?460:(460-self.navigationController.navigationBar.frame.size.height));
    self.view=view;
    [view release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //data
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        [array addObject:[NSString stringWithFormat:@"Row %d",i]];
    }
    self.arrayHistory=array;
    [array release];
    
    
    //ui
    self.title=[NSString stringWithFormat:NSLocalizedString(@"Chating with %@", nil),_theOtherOne];
    
    
    //聊天记录
    UITableView * table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    table.dataSource=self;
    table.delegate=self;
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
//    [btnFace addTarget:self action:@selector(onClickSend:) forControlEvents:UIControlEventTouchUpInside];
    _btnFace = btnFace;
    [ivBg addSubview:btnFace];
    //文字框背景
    UITextField * tf=[[UITextField alloc]init];
    tf.frame=CGRectMake(SINGLE_LINE_HEIGHT*2, 5, ivBg.frame.size.width-SINGLE_LINE_HEIGHT*3, SINGLE_LINE_HEIGHT);
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    tf.userInteractionEnabled=NO;
    [ivBg addSubview:tf];
    _tfBg=tf;
    [tf release];
    //文字框
    UITextView * tv=[[UITextView alloc]init];
    tv.font=[UIFont systemFontOfSize:FONT_SIZE];
    tv.delegate=self;
    tv.backgroundColor=[UIColor clearColor];
    tv.frame=tf.frame;
    tv.keyboardType=UIKeyboardTypeDefault;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    

    
}
-(void)viewDidAppear:(BOOL)animated{
    [self autoMovekeyBoard:0 duration:0.3];
    [self moveTableViewToBottom];
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
    
    
    [self autoMovekeyBoard:0 duration:animationDuration];
}

-(void) autoMovekeyBoard: (float) h duration:(NSTimeInterval)time{
    
    [UIView animateWithDuration:time animations:^{
        _ivBg.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-SINGLE_LINE_HEIGHT-10), 320.0f, SINGLE_LINE_HEIGHT+10);
        
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
        
        _table.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(480.0-h-20-44-SINGLE_LINE_HEIGHT));//通知栏20，导航栏44，编辑框SINGLE_LINE_HEIGHT

    }];
   
	    
    [self moveTableViewToBottom];
    
}
#pragma mark - text view delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"\n%d,%d,%@",range.length,range.location,text);
    if ([@"\n" isEqualToString:text]) {
        //return key
        [self onClickSend:nil];
        return NO;
    }else{
        //common key
        return YES;
    }
    
}
-(void)textViewDidChange:(UITextView *)textView{
    CGSize size = textView.contentSize;
//    NSLog(@"size:%f,%f",size.width,size.height);
    if (size.height>SINGLE_LINE_HEIGHT*2) {
        //大于3行，不再拉伸
        return;
    }
    _tfBg.frame=CGRectMake(_tfBg.frame.origin.x, _tfBg.frame.origin.y, _tfBg.frame.size.width, size.height);
    _tvInput.frame=_tfBg.frame;
    
    CGRect rc=_ivBg.frame;
    rc.size.height=size.height+10;
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
    
    _table.frame = CGRectMake(0.0f, 0.0f, 320.0f,_ivBg.frame.origin.y);
    [self moveTableViewToBottom];
    
}
#pragma mark - funtions
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
        [_tvInput setText:@""];
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
        [self sendMessage:messageStr];
    }
	_tvInput.text = @"";
	[_tvInput resignFirstResponder];
    
    
}
-(void)sendMessage:(NSString*)str{
    [_arrayHistory addObject:str];
    [_table reloadData];
    [self moveTableViewToBottom];
}
#pragma mark - table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentify=@"historyCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.textLabel.text=[_arrayHistory objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayHistory.count;
}
-(void)moveTableViewToBottom{
    NSIndexPath * pi=[NSIndexPath indexPathForRow:_arrayHistory.count-1 inSection:0];
    [_table scrollToRowAtIndexPath:pi atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
