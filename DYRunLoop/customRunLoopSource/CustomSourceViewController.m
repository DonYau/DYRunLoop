//
//  CustomSourceViewController.m
//  DYRunLoop
//
//  Created by DonYau on 2017/9/3.
//  Copyright © 2017年 DonYau. All rights reserved.
//

#import "CustomSourceViewController.h"
#import "DYCustomSourceThread.h"

@interface CustomSourceViewController (){
    DYCustomSourceThread *_customThread;

}

@end

@implementation CustomSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)startCustomSourceThread:(id)sender {
    _customThread = [[DYCustomSourceThread alloc] init];
    [_customThread setName:@"com.donyau.thread"];
    [_customThread start];
}

- (IBAction)executeThread:(id)sender {
    [_customThread.runLoopSource wakeUpRunLoop];

}

- (IBAction)removeCustomSource:(id)sender {
    [_customThread.runLoopSource invalidate];

}

@end
