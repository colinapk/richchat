//
//  NHPlayer.h
//  snowball
//
//  Created by jia wang on 1/27/13.
//  Copyright (c) 2013 Chinese Online Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class NHPlayer;
@protocol NHPlayerDelegate<NSObject>
@optional
-(void)NHPlayer:(NHPlayer *)player onProgress:(CGFloat)progress;
@end
@interface NHPlayer : NSObject<AVAudioPlayerDelegate
                                ,AVAudioSessionDelegate
                                ,AVAudioRecorderDelegate>{
    
}
@property(nonatomic,strong)AVAudioPlayer  *audioPlayer;
@property(nonatomic,strong)AVAudioRecorder * audioRecorder;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)id<NHPlayerDelegate> delegate;

-(void)playFile:(NSString *)strFilePath;
-(void)recordTo:(NSString *)strFilePath;
-(void)playFileData:(NSData *)data;
-(void)playFileOnline:(NSString *)strUrl;
@end
