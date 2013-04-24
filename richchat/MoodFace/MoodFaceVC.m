//
//  MoodFaceVC.m
//  ReleaseTools
//
//  Created by Zhang lu on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoodFaceVC.h"

#define ISIPAD NO
#define R(x,y,w,h) CGRectMake(x,y,w,h)
#define FACES_FOLDER @"faces"

@implementation MoodFaceVC
@synthesize mArrFacesImgName;
@synthesize mArrFaceNames;
@synthesize mArrImgInTextview;
@synthesize mNWordSize;
@synthesize mNImgSize;
@synthesize mNWith;
@synthesize mScrollView;
@synthesize mPageControl;



- (void)dealloc
{
  [mPageControl release];
  [mScrollView release];
  [mArrImgInTextview release];
  [mArrFaceNames release];
  [mArrFacesImgName release];
  [super dealloc];
}



          



-(id)init
{
  if (self = [super init]) {
    mArrFacesImgName = [[NSArray alloc] initWithObjects:
                        @"face_0", @"face_1", @"face_2",@"face_3", @"face_4",
                        @"face_5", @"face_6", @"face_7",@"face_8", @"face_9",
                        @"face_10", @"face_11", @"face_12",@"face_13", @"face_14",
                        @"face_15", @"face_16", @"face_17",@"face_18", @"face_19",
                        @"face_20", @"face_21", @"face_22",@"face_23", @"face_24",
                        @"face_25",
                        @"face_26",@"face_27",@"face_28",@"face_29",@"face_30",
                        @"face_31",@"face_32",@"face_33",@"face_34",@"face_35",
                        @"face_36",@"face_37",@"face_38",@"face_39",@"face_40",
                        @"face_41",@"face_42",@"face_43",@"face_44",@"face_45",
                        @"face_46",@"face_47",@"face_48",@"face_49",@"face_50",
                        @"face_51",@"face_52",@"face_53",@"face_54",@"face_55",
                        @"face_56",nil];
    
    mArrFaceNames = [[NSArray alloc] initWithObjects:
                     NSLocalizedString(@"[白眼]",@"")
                     ,NSLocalizedString(@"[闭嘴]",@"")
                     ,NSLocalizedString(@"[不爽]",@"")
                     ,NSLocalizedString(@"[二]",@"")
                     ,NSLocalizedString(@"[干活]",@"")
                     
                     ,NSLocalizedString(@"[给力]",@"")
                     ,NSLocalizedString(@"[汗]",@"")
                     ,NSLocalizedString(@"[坏笑]",@"")
                     ,NSLocalizedString(@"[可怜]",@"")
                     ,NSLocalizedString(@"[哭]",@"")
                     
                     ,NSLocalizedString(@"[酷]",@"")
                     ,NSLocalizedString(@"[萌]",@"")
                     ,NSLocalizedString(@"[拍砖]",@"")
                     ,NSLocalizedString(@"[庆祝]",@"")
                     ,NSLocalizedString(@"[兔子]",@"")
                     
                     ,NSLocalizedString(@"[微笑]",@"")
                     ,NSLocalizedString(@"[握手]",@"")
                     ,NSLocalizedString(@"[无辜]",@"")
                     ,NSLocalizedString(@"[鲜花]",@"")
                     ,NSLocalizedString(@"[笑]",@"")
                     
                     ,NSLocalizedString(@"[熊猫]",@"")
                     ,NSLocalizedString(@"[郁闷]",@"")
                     ,NSLocalizedString(@"[眨眼]",@"")
                     ,NSLocalizedString(@"[震惊]",@"")
                     ,NSLocalizedString(@"[抓狂]",@"")
                     ,NSLocalizedString(@"[对不起]",@"")
                     
                     ,NSLocalizedString(@"[胜利]",@"")
                     ,NSLocalizedString(@"[烧香]",@"")
                     ,NSLocalizedString(@"[炸弹]",@"")
                     ,NSLocalizedString(@"[撇嘴]",@"")
                     ,NSLocalizedString(@"[饭饭]",@"")
                     ,NSLocalizedString(@"[鄙视]",@"")
                     
                     ,NSLocalizedString(@"[扁你]",@"")
                     ,NSLocalizedString(@"[猪猪]",@"")
                     ,NSLocalizedString(@"[猪头]",@"")
                     ,NSLocalizedString(@"[傲娇]",@"")
                     ,NSLocalizedString(@"[含泪]",@"")
                     ,NSLocalizedString(@"[汉堡]",@"")
                     
                     ,NSLocalizedString(@"[汗]",@"")
                     ,NSLocalizedString(@"[炮灰]",@"")
                     ,NSLocalizedString(@"[呕吐]",@"")
                     ,NSLocalizedString(@"[不理你]",@"")
                     ,NSLocalizedString(@"[酸酸]",@"")
                     ,NSLocalizedString(@"[花束]",@"")
                     
                     ,NSLocalizedString(@"[花痴]",@"")
                     ,NSLocalizedString(@"[囧]",@"")
                     ,NSLocalizedString(@"[忙碌]",@"")
                     ,NSLocalizedString(@"[火冒三丈]",@"")
                     ,NSLocalizedString(@"[色色]",@"")
                     ,NSLocalizedString(@"[加油]",@"")
                     
                     ,NSLocalizedString(@"[无聊]",@"")
                     ,NSLocalizedString(@"[怒]",@"")
                     ,NSLocalizedString(@"[噢耶]",@"")
                     ,NSLocalizedString(@"[蛋糕]",@"")
                     ,NSLocalizedString(@"[过分]",@"")
                     ,NSLocalizedString(@"[怪笑]",@"")
                     ,NSLocalizedString(@"[鼓掌]",@""),nil];
  }
  
  return self;
}



#pragma mark - View lifecycle
- (void)loadView
{
  CGRect rFrameMain = [UIScreen mainScreen].bounds;
  UIView *aView = [[UIView alloc] initWithFrame:ISIPAD?R(0,0,414,183.5):R(0,265,rFrameMain.size.width,rFrameMain.size.height-265)];
  aView.backgroundColor = [UIColor clearColor];
  self.view =aView;
  [aView release];
  
  if (ISIPAD) {
    UIImageView *aImgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiley_bj"]];
    aImgBg.userInteractionEnabled = YES;
    aImgBg.frame = self.view.bounds;
    [self.view addSubview:aImgBg];
    [aImgBg release];
  }
  
  mScrollView = [[UIScrollView alloc] initWithFrame:R(ISIPAD?17:0, ISIPAD?10:0, ISIPAD?(self.view.frame.size.width-30):self.view.frame.size.width, ISIPAD?(self.view.frame.size.height-55):(self.view.frame.size.height-30))];
  mScrollView.backgroundColor = [UIColor clearColor];
  mScrollView.userInteractionEnabled = YES;
  mScrollView.showsHorizontalScrollIndicator = NO;
  mScrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:mScrollView];
  
  
  mPageControl = [[UIPageControl alloc] initWithFrame:R(mScrollView.frame.origin.x, mScrollView.frame.origin.y+mScrollView.frame.size.height, mScrollView.frame.size.width, 30)];
  mPageControl.backgroundColor = [UIColor clearColor];
  mPageControl.numberOfPages = 0;
  mPageControl.hidesForSinglePage = YES;
  [mPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:mPageControl];
  
  CGFloat fX = 8;
  CGFloat fY = ISIPAD?5:15;
  CGFloat fW = 30;
  CGFloat fContentX = fX;
  CGFloat fContentY = fY;
  NSInteger nLevel = 0;
  NSInteger nFlag = 0;
  NSInteger nCurRow = 7;
  NSInteger nCurCol = ISIPAD?3:4;
  for (NSString *aStr in mArrFacesImgName) {
    if ((!(nFlag%nCurRow))&&(nFlag != 0)) {
      fX = mScrollView.frame.size.width*nLevel + fContentX;
      fY += fW+12;
    }

    if ((!(nFlag % (nCurCol*nCurRow))) && (nFlag != 0)) {
      nLevel++;
      fX = mScrollView.frame.size.width*nLevel + fContentX;
      fY = fContentY;
    }

    NSString *aStrFace = [NSString stringWithFormat:@"%@", aStr];
      UIImage * img=[UIImage imageNamed:aStrFace];
      UIButton *aBtn =[[UIButton alloc]init];
     aBtn.frame = R(fX, fY, fW, fW);
    aBtn.tag = nFlag++;
      [aBtn setBackgroundImage:img forState:UIControlStateNormal];
      [aBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [mScrollView addSubview:aBtn];
    [aBtn release];
    fX += 25+aBtn.frame.size.width;
  }
  
  //设置contentsize
  CGSize aContentSize = mScrollView.contentSize;
  aContentSize.width = (nLevel+1)*mScrollView.frame.size.width;
  aContentSize.height = mScrollView.frame.size.height;
  mScrollView.contentSize = aContentSize;
  mScrollView.pagingEnabled = YES;
  mScrollView.delegate = self;
  mPageControl.numberOfPages = nLevel+1;
  
  NSInteger aFlagNum = 0;
  for (UIImageView *aImg in mPageControl.subviews) {
    if (aFlagNum == 0) {
      aImg.image = [UIImage imageNamed:@"pagecontrol_black"];
    }else{
      aImg.image = [UIImage imageNamed:@"pagecontrol_gray"];
    }
    
    aFlagNum++;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  mNImgSize = 28;
  mNWordSize = 10;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollview Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  int page = scrollView.contentOffset.x / mScrollView.frame.size.width;
  mPageControl.currentPage = page;
  
  NSInteger aFlagNum = 0;
  for (UIImageView *aImg in mPageControl.subviews) {
    if (aFlagNum == page) {
      aImg.image = [UIImage imageNamed:@"pagecontrol_black"];
    }else{
      aImg.image = [UIImage imageNamed:@"pagecontrol_gray"];
    }
    
    aFlagNum++;
  }
}

#pragma mark - function
- (void)changePage:(id)sender{
  int page = mPageControl.currentPage;
  [mScrollView setContentOffset:CGPointMake(mScrollView.frame.size.width * page, 0)];
  
  NSInteger aFlagNum = 0;
  for (UIImageView *aImg in mPageControl.subviews) {
    if (aFlagNum == page) {
      aImg.image = [UIImage imageNamed:@"pagecontrol_black"];
    }else{
      aImg.image = [UIImage imageNamed:@"pagecontrol_gray"];
    }
    
    aFlagNum++;
  }
}

- (NSString *)getImgShortPath:(NSString *)aDescription{
  NSString *aStrImgPath=@"";
  
  NSInteger aFlag = 0;
  for (NSString *aStrName in mArrFaceNames) {
    if ([aStrName isEqualToString:aDescription]) {
      aStrImgPath = [mArrFacesImgName objectAtIndex:aFlag];
      break;
    }
    
    aFlag++;
  }
  
  NSString *aStrImgPathFace = [NSString stringWithFormat:@"%@", aStrImgPath];
  
  return aStrImgPathFace;
}


- (NSString *)getImgPathName:(NSString *)aDescription
{
  NSString *aStrImgPath=@"";
  
  NSInteger aFlag = 0;
  for (NSString *aStrName in mArrFaceNames) {
    if ([aStrName isEqualToString:aDescription]) {
      aStrImgPath = [mArrFacesImgName objectAtIndex:aFlag];
      break;
    }
    
    aFlag++;
  }
  
  NSString *aStrImgPathFace = [NSString stringWithFormat:@"%@", aStrImgPath];
  NSString *aStrFullPath = aStrImgPathFace;

  
  return aStrFullPath;
}



- (void)clickButton:(id)sender
{    
  UIButton *aBtn = (UIButton *)sender;

  NSString *aStrShow = [mArrFaceNames objectAtIndex:aBtn.tag];
  NSString *aStrFaceImgPath = [NSString stringWithFormat:@"%@", [mArrFacesImgName objectAtIndex:aBtn.tag]];
  
  NSDictionary *aDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                        aStrShow, @"face",aStrFaceImgPath, @"imgpath", nil];
//  [[NSNotificationCenter defaultCenter] postNotificationName:MOODFACE_SELECT object:nil userInfo:aDic];
  [aDic release];
  
}

- (NSString *)convertToImagedView:(NSString *)aStr
{
  NSMutableArray *aArrFace = [[NSMutableArray alloc] init];

  if (aStr) {
    NSString *aMutableString = [[[NSString alloc] initWithString:aStr] autorelease];
    NSArray *aArr = [aMutableString componentsSeparatedByString:@"["];
    for (NSString *aStr in aArr) {
      NSArray *aArrIn = [aStr componentsSeparatedByString:@"]"];
      if ([aArrIn count] == 2) {
        [aArrFace addObject:[aArrIn objectAtIndex:0]];
      } 
    }
    
    for (NSString *aStr in aArrFace) {
      NSString *aStrFormat = [NSString stringWithFormat:@"[%@]", aStr];
      NSString *aStrImgPath = [self getImgPathName:aStrFormat];
      NSString *aStrWeb = [NSString stringWithFormat:@"  <img src=\"%@\" width=\"%d\" height=\"%d\"/>  ", aStrImgPath, mNImgSize, mNImgSize];
      
      aMutableString = [aMutableString stringByReplacingOccurrencesOfString:aStrFormat withString:aStrWeb];
    }
    
    NSString *aStrBody = [[NSString alloc] initWithFormat:@"<body><font face=\"Heiti SC\" size=\"%d\">%@</font></body>", mNWordSize,aMutableString];
    
    [aArrFace release];
    return [aStrBody autorelease];
  }

  
  [aArrFace release];
  return nil;

}

//imageview + label 格式
#define BEGIN_FLAG @"["
#define END_FLAG @"]"

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
  NSRange range=[message rangeOfString: BEGIN_FLAG];
  NSRange range1=[message rangeOfString: END_FLAG];
  
  //判断当前字符串是否还有表情的标志。
  if (range.length && range1.length) {
    if (range.location>0) {
      [array addObject:[message substringToIndex:range.location]];
      [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
      NSString *str=[message substringFromIndex:range1.location+1];
      [self getImageRange:str :array];
    }else {
      NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
      
      //排除文字是“”的
      if (![nextstr isEqualToString:@""]) {
        [array addObject:nextstr];
        NSString *str=[message substringFromIndex:range1.location+1];
        [self getImageRange:str :array];
      }else {
        return;
      }
    }
  }else {
    if (message != nil) {
      [array addObject:message];
    }
  }
}

#define KFacialSizeWidth (ISIPAD?30:22)
#define KFacialSizeHeight (ISIPAD?30:22)
#define KImgInterval 5

-(UIView *)assembleMessageAtIndex : (NSString *) message
{
  if (message) {
    if (message.length > 0) {
      if ([message isEqualToString:@" "]) {
        UIView *returnView = [[UIView alloc] initWithFrame:R(1, 1, 1, 1)];
        return returnView;
      }
    }else{
      return nil;
    }
  }else{
    return nil;
  }
  
  NSMutableArray *array = [[NSMutableArray alloc] init];
  [self getImageRange:message :array];
  UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
  returnView.backgroundColor = [UIColor clearColor];
  NSArray *data = array;
  UIFont *fon = [UIFont systemFontOfSize:18];

  CGFloat upX = 0;
  CGFloat upY = 0;
  CGFloat fH = 0;

  if (data) {
    for (int i=0;i<[data count];i++) {
      NSString *str=[data objectAtIndex:i];
      
      if ([str hasPrefix: BEGIN_FLAG]&&[str hasSuffix: END_FLAG])
      {
        if (upX > mNWith)
        {
          upY = upY + KFacialSizeHeight;
          upX = 0;
        }
        
        NSString *aImgPath = [self getImgShortPath:str];
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:aImgPath]];
        img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
        [returnView addSubview:img];
        
        upX += KFacialSizeWidth+KImgInterval;
        fH = img.frame.origin.y+img.frame.size.height;
        
        [img release];
      } else {
        for (int j = 0; j < [str length]; j++) {
          NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
          if (upX > mNWith)
          {
            upY = upY + KFacialSizeHeight;
            upX = 0;
          }
          
          CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(1000, 40)];
          UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY+5,size.width,size.height)];
          la.backgroundColor = [UIColor clearColor];
          la.font = fon;
          la.text = temp;
          [returnView addSubview:la];
          upX=upX+size.width;
          
          fH = la.frame.origin.y+la.frame.size.height;
          
          [la release];
        }
        
        upX += KImgInterval;
      }
    }
  }
  
  [array release];
  returnView.frame = CGRectMake(0, 0, upX, fH); //需要将该view的尺寸记下，方便以后使用
  return [returnView autorelease];
}


@end
