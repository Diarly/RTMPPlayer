//
//  ViewController.m
//  RTMPPlayer
//
//  Created by guofeixu on 16/5/11.
//  Copyright © 2016年 guofeixu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rtmp:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"rtmpPush" sender:self];
}

@end
