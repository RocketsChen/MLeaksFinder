//
//  UIApplication+MemoryLeak.m
//  MLeaksFinder
//
//  Created by 佘泽坡 on 5/11/16.
//  Copyright © 2016 zeposhe. All rights reserved.
//

#import "UIApplication+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>

#ifdef DEBUG

extern const void *const kLatestSenderKey;

@implementation UIApplication (MemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(sendAction:to:from:forEvent:) withSEL:@selector(swizzled_sendAction:to:from:forEvent:)];
    });
}

- (BOOL)swizzled_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    objc_setAssociatedObject(self, kLatestSenderKey, sender, OBJC_ASSOCIATION_ASSIGN);
    
    return [self swizzled_sendAction:action to:target from:sender forEvent:event];
}

@end

#endif
