//
//  RTMPViewController.m
//  testThread
//
//  Created by guofeixu on 16/5/11.
//  Copyright © 2016年 guofeixu. All rights reserved.
//

#import "RTMPViewController.h"
#import "RTMPPlayer.h"
#import "OpenGLView20.h"

@interface RTMPViewController ()<RTMPPlayerDelegate>


@property (strong, nonatomic) RTMPPlayer *player;
@property (strong, nonatomic) OpenGLView20 *playerView;

@end

@implementation RTMPViewController


@synthesize player;
@synthesize playerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    playerView = [[OpenGLView20 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:playerView];
    
    
    player = [[RTMPPlayer alloc] initWithUrl:@"rtmp://ftv.sun0769.com/dgrtv1/mp4:b1" width:self.view.bounds.size.height height:self.view.bounds.size.width];
    player.delegate = self;
    
    [player play];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)player:(RTMPPlayer *)player data:(void *)yuvData{
    
    [playerView displayYUV420pData:yuvData width:480 height:360];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
