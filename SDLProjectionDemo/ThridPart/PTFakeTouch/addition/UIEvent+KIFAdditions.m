//
//  UIEvent+KIFAdditions.m
//  KIF
//
//  Created by Thomas on 3/1/15.
//
//

#import "UIEvent+KIFAdditions.h"
#import "LoadableCategory.h"
#import "IOHIDEvent+KIF.h"
#import "NSString+KIFAdditions.h"

KW_FIX_CATEGORY_BUG_M(UIEvent_KIFAdditions)

MAKE_CATEGORIES_LOADABLE(UIEvent_KIFAdditions)

@implementation UIEvent (KIFAdditionsPrivateHeaders)
- (void)sg_addTouch:(UITouch *)touch forDelayedDelivery:(BOOL)arg2 {
    NSString *selectorEncoded = @"X2FkZFRvdWNoOmZvckRlbGF5ZWREZWxpdmVyeTo=";     // _addTouch:forDelayedDelivery:
    SEL selector = NSSelectorFromString([selectorEncoded stringBase64Decoded]);
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&touch atIndex:2];
    [invocation setArgument:&arg2 atIndex:3];
    [invocation invoke];
}

- (void)sg_clearTouches {
    NSString *selectorEncoded = @"X2NsZWFyVG91Y2hlcw==";     // _clearTouches
    SEL selector = NSSelectorFromString([selectorEncoded stringBase64Decoded]);
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation invoke];
}

- (void)sg_setGSEvent:(GSEventRef)event {
    NSString *selectorEncoded = @"X3NldEdTRXZlbnQ6";     // _setGSEvent:
    SEL selector = NSSelectorFromString([selectorEncoded stringBase64Decoded]);
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&event atIndex:2];
    [invocation invoke];
}

- (void)sg_setHIDEvent:(IOHIDEventRef)event {
    NSString *selectorEncoded = @"X3NldEhJREV2ZW50Og==";     // _setHIDEvent:
    SEL selector = NSSelectorFromString([selectorEncoded stringBase64Decoded]);
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&event atIndex:2];
    [invocation invoke];
}

- (void)sg_setTimestamp:(NSTimeInterval)timestemp {
    NSString *selectorEncoded = @"X3NldFRpbWVzdGFtcDo=";     // _setTimestamp:
    SEL selector = NSSelectorFromString([selectorEncoded stringBase64Decoded]);
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&timestemp atIndex:2];
    [invocation invoke];
}

@end
//
// GSEvent is an undeclared object. We don't need to use it ourselves but some
// Apple APIs (UIScrollView in particular) require the x and y fields to be present.
//
@interface KIFGSEventProxy : NSObject
{
@public
    unsigned int flags;
    unsigned int type;
    unsigned int ignored1;
    float x1;
    float y1;
    float x2;
    float y2;
    unsigned int ignored2[10];
    unsigned int ignored3[7];
    float sizeX;
    float sizeY;
    float x3;
    float y3;
    unsigned int ignored4[3];
}
@end

@implementation KIFGSEventProxy
@end

@implementation UIEvent (KIFAdditions)

- (void)kif_setEventWithTouches:(NSArray *)touches
{
    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]
        && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [self kif_setIOHIDEventWithTouches:touches];
    } else {
        [self kif_setGSEventWithTouches:touches];
    }
}

- (void)kif_setGSEventWithTouches:(NSArray *)touches
{
    UITouch *touch = touches[0];
    CGPoint location = [touch locationInView:touch.window];
    KIFGSEventProxy *gsEventProxy = [[KIFGSEventProxy alloc] init];
    gsEventProxy->x1 = location.x;
    gsEventProxy->y1 = location.y;
    gsEventProxy->x2 = location.x;
    gsEventProxy->y2 = location.y;
    gsEventProxy->x3 = location.x;
    gsEventProxy->y3 = location.y;
    gsEventProxy->sizeX = 1.0;
    gsEventProxy->sizeY = 1.0;
    gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
    gsEventProxy->type = 3001;
    
    [self sg_setGSEvent:(GSEventRef)gsEventProxy];
    
    [self sg_setTimestamp:(((UITouch*)touches[0]).timestamp)];
}

- (void)kif_setIOHIDEventWithTouches:(NSArray *)touches
{
    IOHIDEventRef event = kif_IOHIDEventWithTouches(touches);
    [self sg_setHIDEvent:event];
    CFRelease(event);
}

@end
