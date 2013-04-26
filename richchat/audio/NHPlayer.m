//
//  NHPlayer.m
//  snowball
//
//  Created by jia wang on 1/27/13.
//  Copyright (c) 2013 Chinese Online Corporation. All rights reserved.
//

#import "NHPlayer.h"


@implementation NHPlayer
@synthesize audioPlayer=_audioPlayer;
@synthesize audioRecorder=_audioRecorder;
@synthesize timer=_timer;
@synthesize delegate=_delegate;


-(id)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
-(void)dealloc{
    if (_audioPlayer) {
        [_audioPlayer stop];
        [_audioPlayer setDelegate:nil];
        [_audioPlayer release];
        _audioPlayer = nil;
    }
    if (_audioRecorder) {
        [_audioRecorder stop];
        [_audioRecorder setDelegate:nil];
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    [super dealloc];
}
-(void)playFileData:(NSData *)data{
    if (_audioPlayer) {
        [_audioPlayer stop];
        [_audioPlayer release];
        _audioPlayer = nil;
    }
    if (_timer) {
        [_timer release];
        _timer=nil;
    }

    if (data && [data isKindOfClass:[NSData class]]) {
        NSError * error=[[NSError alloc]init];
        AVAudioPlayer * player=[[AVAudioPlayer alloc]initWithData:data error:&error];
        
        if (!player) {
            //handle error
            NSLog(@"Failed to play ");
        }else{
            player.delegate=self;
            self.audioPlayer=player;
            _audioPlayer.numberOfLoops=0;
            [_audioPlayer prepareToPlay];
            [_audioPlayer play];
            
            NSTimer * timer=[NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
            [timer fire];
            self.timer=timer;
            
            
        }
        [player release];
        [error release];
    }

}
-(void)playFile:(NSString *)strFilePath{
    NSData * data=[[NSData alloc]initWithContentsOfFile:strFilePath];
    [self playFileData:data];
    [data release];
    
}
-(void)recordTo:(NSString *)strFilePath{
    if (_audioRecorder) {
        [_audioRecorder stop];
        [_audioRecorder release];
        _audioRecorder = nil;
    }
    
  
    NSURL *destinationURL = [NSURL fileURLWithPath: strFilePath];
    NSError * error;

    AVAudioRecorder * recorder=[[AVAudioRecorder alloc]initWithURL:destinationURL settings:nil error:&error];
    
    if (!recorder) {
        //handle error
        NSLog(@"Failed to record %@",strFilePath);
    }else{
        recorder.delegate=self;
        self.audioRecorder=recorder;
        [recorder prepareToRecord];
        [recorder record];
    }
    [recorder release];
    
   
    
}

-(void)onTimer:(NSTimer *)timer{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(NHPlayer:onProgress:)]) {
            [self.delegate NHPlayer:self onProgress:_audioPlayer.currentTime/_audioPlayer.duration];
        }
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_timer invalidate];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(NHPlayer:onProgress:)]) {
            [self.delegate NHPlayer:self onProgress:1];
        }
    }
}
@end
