//
//  RTMPPlayer.h
//  testThread
//
//  Created by guofeixu on 16/5/11.
//  Copyright © 2016年 guofeixu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libavcodec/avcodec.h>
#import <libavformat/avformat.h>
#import <libswscale/swscale.h>

@class RTMPPlayer;
@protocol RTMPPlayerDelegate <NSObject>

- (void)player:(RTMPPlayer *)player data:(void *)yuvData;

@end

@interface RTMPPlayer : NSObject

@property (weak, nonatomic) id <RTMPPlayerDelegate>delegate;

- (id)initWithUrl:(NSString *)url width:(int)outputWidth height:(int)outputHeight;

- (void)play;

- (void)stop;
@end
