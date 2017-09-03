//
//  DYCustomSourceThread.h
//  DYRunLoop
//
//  Created by DonYau on 2017/9/3.
//  Copyright © 2017年 DonYau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYRunLoopSource.h"

@interface DYCustomSourceThread : NSThread

@property (nonatomic, strong) DYRunLoopSource *runLoopSource;

@end
