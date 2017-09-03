//
//  DYRunLoopSource.h
//  DYRunLoop
//
//  Created by DonYau on 2017/9/3.
//  Copyright © 2017年 DonYau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYRunLoopSource : NSObject

//将输入源添加到RunLoop
- (void)addToCurrentRunLoop;

//移除输入源
- (void)invalidate;

//唤醒RunLoop
- (void)wakeUpRunLoop;

@end
