//
//  MoodFaceVC.h
//  ReleaseTools
//
//  Created by Zhang lu on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGES_DIR @"Images"
#define FACES_FOLDER @"Expression"
@class MoodFaceVC;
@protocol MoodFaceDelegate <NSObject>

@required
-(void)moodFaceVC:(MoodFaceVC *)vc selected:(NSString *)strDescription imageName:(NSString *)strImg;

@end
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
@property (assign, nonatomic) id<MoodFaceDelegate> delegate;

- (void)clickButton:(id)sender;

- (NSString *)getImgPathName:(NSString *)aDescription;
- (NSString *)convertToImagedView:(NSString *)aStr;
//获得图文混排视图
- (UIView *)assembleMessageAtIndex : (NSString *) message;
- (NSString *)getImgShortPath:(NSString *)aDescription;
@end
