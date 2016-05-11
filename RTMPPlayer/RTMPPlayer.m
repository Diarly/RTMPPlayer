//
//  RTMPPlayer.m
//  testThread
//
//  Created by guofeixu on 16/5/11.
//  Copyright © 2016年 guofeixu. All rights reserved.
//

#import "RTMPPlayer.h"

@interface RTMPPlayer (){
    
    AVFormatContext *ifmt_ctx;
    AVCodecContext *videoCodec_ctx;
    AVCodecContext *audioCodec_ctx;
    AVFrame *pFrame;
    AVPacket pkt;
    
    
    int video_index;
    int audio_index;
    
}

@property (strong, nonatomic) NSString *filePath;
@property (assign, nonatomic) int oWidth;
@property (assign, nonatomic) int oHeight;

@end

@implementation RTMPPlayer

@synthesize filePath;
@synthesize oWidth;
@synthesize oHeight;


- (id)init{
    
    if (self = [super init]) {
        
        
        av_register_all();
        avformat_network_init();
        video_index = -1;
        audio_index = -1;
        
        
    }
    return self;
}



- (id)initWithUrl:(NSString *)url{
    
    if (self = [self init]) {
        
        filePath = url;
        
        if (avformat_open_input(&ifmt_ctx, [self.filePath UTF8String], NULL, NULL) < 0) {
            
            NSLog(@"打开文件失败");
            goto initError;
        }
        
        if (avformat_find_stream_info(ifmt_ctx, NULL) < 0) {
            
            NSLog(@"未发现流");
            goto initError;
        }
        
        av_dump_format(ifmt_ctx, 0, [self.filePath UTF8String], 0);
        
        
        
        for (int i = 0; i < ifmt_ctx->nb_streams; i++) {
            
            
            AVStream *stream = ifmt_ctx->streams[i];
            if (stream->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
                
                NSLog(@"视频流");
                video_index = i;
                videoCodec_ctx = stream->codec;
                
                
            }else if (stream->codec->codec_type == AVMEDIA_TYPE_AUDIO){
                
                NSLog(@"音频流");
                audio_index = i;
                audioCodec_ctx = stream->codec;
            }
        }
        
        AVCodec *videoCodec = avcodec_find_decoder(videoCodec_ctx->codec_id);
        
        if (videoCodec == NULL) {
            
            NSLog(@"没有发现视频解码器");
        }
        
        AVCodec *audioCodec = avcodec_find_decoder(audioCodec_ctx->codec_id);
        
        if (audioCodec == NULL) {
            
            NSLog(@"没有发现音频解码器");
        }
        
        if (avcodec_open2(videoCodec_ctx, videoCodec, NULL) < 0) {
            
            NSLog(@"Couldn't open video codec");
        }
        
        if (avcodec_open2(audioCodec_ctx, audioCodec, NULL) < 0) {
            
            NSLog(@"Couldn't open audio codec");
        }
        
        pFrame = av_frame_alloc();
        
        
        
    }
    return self;
    
initError:
    return nil;
}

- (id)initWithUrl:(NSString *)url width:(int)outputWidth height:(int)outputHeight{
    
    if (self = [self initWithUrl:url]) {
        
        oWidth = outputWidth;
        oHeight = outputHeight;
    }
    return self;
}

- (void)play{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        while (1) {
            
            if (av_read_frame(ifmt_ctx, &pkt) < 0) {
                
                break;
            }
            
            if (pkt.stream_index == video_index) {
                
                NSLog(@"播放视频数据");
                int got_picture = 0;
                int decode = avcodec_decode_video2(videoCodec_ctx, pFrame, &got_picture, &pkt);
                
                if (decode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self yuvData:pFrame];
                    });
                    
                    
                }
                
            }else if (pkt.stream_index == audio_index){
                
                NSLog(@"添加音频数据");
            }
            
            
        }
        
    });
    

}

- (void)stop{
    
    
    
}

- (void)yuvData:(AVFrame *)frame{
    
    int width = videoCodec_ctx->width;
    int height = videoCodec_ctx->height;
    uint8_t *yuv420pData = malloc(width * height * 3/2);
    
    //Y
    int offset = 0;
    for (int i = 0; i < height; i++) {
        
        if (pFrame->data[0]) {
            
            memcpy(yuv420pData + offset, pFrame->data[0] + i * pFrame->linesize[0], width);
            offset += width;
        }
        
    }
    //U
    for (int i=0; i<height/2; i++)
    {
        if (pFrame->data[1]) {
            
            memcpy(yuv420pData + offset,pFrame->data[1] + i * pFrame->linesize[1], width/2);
            offset += width/2;
        }
        
    }
    
    
    //V
    for (int i=0; i<height/2; i++)
    {
        if (pFrame->data[2]) {
            
            memcpy(yuv420pData + offset,pFrame->data[2] + i * pFrame->linesize[2], width/2);
            offset += width/2;
        }
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:data:)]) {
        
        [self.delegate player:self data:yuv420pData];
        
    }
    
    free(yuv420pData);
}

@end
