//
//  MoodFaceVC.h
//  ReleaseTools
//
//  Created by Zhang lu on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodFaceVC : UIViewController
<UIScrollViewDelegate>

@property (strong, nonatomic) UIPageControl *mPageControl;
@property (strong, nonatomic) UIScrollView *mScrollView;
@property (strong, nonatomic) NSArray *mArrFacesImgName;
@property (strong, nonatomic) NSArray *mArrFaceNames;
@property (strong, nonatomic) NSMutableArray *mArrImgInTextview;
@property (assign, nonatomic) NSInteger mNWordSize;
@property (assign, nonatomic) NSInteger mNImgSize;
@property (assign, nonatomic) NSInteger mNWith;

+ (MoodFaceVC *)sharedInstance;
+(void)destroy;
- (void)clickButton:(id)sender;
- (void)hideOrShowAnimation:(BOOL)aIsHide;
- (NSString *)getImgPathName:(NSString *)aDescription;
- (NSString *)convertToImagedView:(NSString *)aStr;
- (UIView *)assembleMessageAtIndex : (NSString *) message;
- (NSString *)getImgShortPath:(NSString *)aDescription;
@end
