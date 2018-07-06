//
//  HJFakeMetaTouch.m
//  HJFakeTouch
//
//  Created by PugaTang on 16/4/20.
//  Copyright © 2016年 PugaTang. All rights reserved.
//

#import "PTFakeMetaTouch.h"
#import "UITouch-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIEvent+KIFAdditions.h"
//#import "fishhook.h"
#import "IOHIDEvent+KIF.h"
#include <dlfcn.h>
//#import "PLPatchMaster.h"
static void (*orig_IOHIDEventAppendEvent)(IOHIDEventRef event, IOHIDEventRef childEvent);
static IOHIDEventRef (*orig_IOHIDEventCreateDigitizerEvent)(CFAllocatorRef allocator, AbsoluteTime timeStamp, IOHIDDigitizerTransducerType type,
                                                            uint32_t index, uint32_t identity, uint32_t eventMask, uint32_t buttonMask,
                                                            IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat barrelPressure,
                                                            Boolean range, Boolean touch, IOOptionBits options);
static IOHIDEventRef (*orig_IOHIDEventCreateDigitizerFingerEventWithQuality)(CFAllocatorRef allocator, AbsoluteTime timeStamp,
                                                                             uint32_t index, uint32_t identity, uint32_t eventMask,
                                                                             IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist,
                                                                             IOHIDFloat minorRadius, IOHIDFloat majorRadius, IOHIDFloat quality, IOHIDFloat density, IOHIDFloat irregularity,
                                                                             Boolean range, Boolean touch, IOOptionBits options);
static void (*orig_IOHIDEventSetIntegerValue)(IOHIDEventRef event, IOHIDEventField field, int value);



void sg_IOHIDEventAppendEvent(IOHIDEventRef event, IOHIDEventRef childEvent) {
    //    AppDelegate().logTextView.text = @"sg_IOHIDEventAppendEvent";
    if (orig_IOHIDEventAppendEvent) {
        orig_IOHIDEventAppendEvent(event, childEvent);
    }
}

IOHIDEventRef sg_IOHIDEventCreateDigitizerEvent(CFAllocatorRef allocator, AbsoluteTime timeStamp, IOHIDDigitizerTransducerType type,
                                                uint32_t index, uint32_t identity, uint32_t eventMask, uint32_t buttonMask,
                                                IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat barrelPressure,
                                                Boolean range, Boolean touch, IOOptionBits options) {
    //    AppDelegate().logTextView.text = @"sg_IOHIDEventCreateDigitizerEvent";
    if (orig_IOHIDEventCreateDigitizerEvent) {
        return orig_IOHIDEventCreateDigitizerEvent(allocator, timeStamp, type,
                                                   index, identity, eventMask, buttonMask,
                                                   x, y, z, tipPressure, barrelPressure,
                                                   range, touch, options);
    }
    return nil;
}
IOHIDEventRef sg_IOHIDEventCreateDigitizerFingerEventWithQuality(CFAllocatorRef allocator, AbsoluteTime timeStamp,
                                                                 uint32_t index, uint32_t identity, uint32_t eventMask,
                                                                 IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist,
                                                                 IOHIDFloat minorRadius, IOHIDFloat majorRadius, IOHIDFloat quality, IOHIDFloat density, IOHIDFloat irregularity,
                                                                 Boolean range, Boolean touch, IOOptionBits options) {
    //    AppDelegate().logTextView.text = @"sg_IOHIDEventCreateDigitizerFingerEventWithQuality";
    if (orig_IOHIDEventCreateDigitizerFingerEventWithQuality) {
        return orig_IOHIDEventCreateDigitizerFingerEventWithQuality(allocator, timeStamp,
                                                                    index, identity, eventMask,
                                                                    x, y, z, tipPressure, twist,
                                                                    minorRadius, majorRadius, quality, density,
                                                                    irregularity,
                                                                    range, touch, options);
    }
    return nil;
}

void sg_IOHIDEventSetIntegerValue(IOHIDEventRef event, IOHIDEventField field, int value) {
    //    AppDelegate().logTextView.text = @"sg_IOHIDEventSetIntegerValue";
    orig_IOHIDEventSetIntegerValue(event, field, value);
}

static NSMutableArray *touchAry;
@implementation HJFakeMetaTouch

+ (void)load{
    KW_ENABLE_CATEGORY(UITouch_KIFAdditions);
    KW_ENABLE_CATEGORY(UIEvent_KIFAdditions);
    
    //        NSString *IOKitLocation = @"/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit";
    //        [[PLPatchMaster master] rebindSymbol: @"_IOHIDEventCreateDigitizerEvent" fromImage: IOKitLocation replacementAddress: (uintptr_t) sg_IOHIDEventCreateDigitizerEvent];
    
    
    UITouch *touch = [[UITouch alloc] initAtPoint:CGPointZero inWindow:[UIApplication sharedApplication].delegate.window];
    [touch setLocationInWindow:CGPointZero];
    [touch setPhaseAndUpdateTimestamp:UITouchPhaseBegan];
    UITouch *touch2 = [[UITouch alloc] initAtPoint:CGPointZero inWindow:[UIApplication sharedApplication].delegate.window];
    [touch2 setLocationInWindow:CGPointZero];
    [touch2 sg_setIsFirstTouchForView:NO];
    
    [touch2 setPhaseAndUpdateTimestamp:UITouchPhaseMoved];
    UITouch *touch3 = [[UITouch alloc] initAtPoint:CGPointZero inWindow:[UIApplication sharedApplication].delegate.window];
    [touch3 setLocationInWindow:CGPointZero];
    [touch3 sg_setIsFirstTouchForView:NO];
    [touch3 setPhaseAndUpdateTimestamp:UITouchPhaseEnded];
    UIEvent *event = [self eventWithTouches:@[touch, touch2, touch3]];
    [[UIApplication sharedApplication] sendEvent:event];
    
    orig_IOHIDEventSetIntegerValue = dlsym(RTLD_DEFAULT, "IOHIDEventSetIntegerValue");
    orig_IOHIDEventAppendEvent = dlsym(RTLD_DEFAULT, "IOHIDEventAppendEvent");
    orig_IOHIDEventCreateDigitizerEvent = dlsym(RTLD_DEFAULT, "IOHIDEventCreateDigitizerEvent");
    orig_IOHIDEventCreateDigitizerFingerEventWithQuality = dlsym(RTLD_DEFAULT, "IOHIDEventCreateDigitizerFingerEventWithQuality");
    
    touchAry = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<100; i++) {
        UITouch *touch = [[UITouch alloc] initTouch];
        [touch setPhaseAndUpdateTimestamp:UITouchPhaseEnded];
        [touchAry addObject:touch];
    }
    
//    int result = rebind_symbols((struct rebinding[4]){
//        {"IOHIDEventSetIntegerValue", sg_IOHIDEventSetIntegerValue, (void *)&orig_IOHIDEventSetIntegerValue},
//        {"IOHIDEventCreateDigitizerEvent", sg_IOHIDEventCreateDigitizerEvent, (void *)&orig_IOHIDEventCreateDigitizerEvent},
//        {"IOHIDEventCreateDigitizerFingerEventWithQuality", sg_IOHIDEventCreateDigitizerFingerEventWithQuality, (void *)&orig_IOHIDEventCreateDigitizerFingerEventWithQuality},
//        {"dl_IOHIDEventAppendEvent", sg_IOHIDEventAppendEvent, (void *)&orig_IOHIDEventAppendEvent},
//    }, 4);
    
//    NSLog(@"rebinded");
}

+ (NSInteger)fakeTouchId:(NSInteger)pointId AtPoint:(CGPoint)point withTouchPhase:(UITouchPhase)phase window:(UIWindow *)window {
    //DLog(@"4. fakeTouchId , phase : %ld ",(long)phase);
    if (pointId==0) {
        //随机一个没有使用的pointId
        pointId = [self getAvailablePointId];
        if (pointId==0) {
//            DLog(@"PTFakeTouch ERROR! pointId all used");
            return 0;
        }
    }
    pointId = pointId - 1;
    UITouch *touch = [touchAry objectAtIndex:pointId];
    if (phase == UITouchPhaseBegan) {
        touch = nil;
        touch = [[UITouch alloc] initAtPoint:point inWindow:window];
        [touchAry replaceObjectAtIndex:pointId withObject:touch];
        [touch setLocationInWindow:point];
    }else{
        [touch setLocationInWindow:point];
        [touch setPhaseAndUpdateTimestamp:phase];
    }
    
    
    
    UIEvent *event = [self eventWithTouches:touchAry];
    [[UIApplication sharedApplication] sendEvent:event];
    if ((touch.phase==UITouchPhaseBegan)||touch.phase==UITouchPhaseMoved) {
        [touch setPhaseAndUpdateTimestamp:UITouchPhaseStationary];
    }
    return (pointId+1);
}


+ (UIEvent *)eventWithTouches:(NSArray *)touches
{
    // _touchesEvent is a private selector, interface is exposed in UIApplication(KIFAdditionsPrivate)
    UIEvent *event = [[UIApplication sharedApplication] sg_touchesEvent];
    [event sg_clearTouches];
    [event kif_setEventWithTouches:touches];
    
    for (UITouch *aTouch in touches) {
        [event sg_addTouch:aTouch forDelayedDelivery:NO];
    }
    
    return event;
}

+ (NSInteger)getAvailablePointId{
    NSInteger availablePointId=0;
    NSMutableArray *availableIds = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i<touchAry.count-50; i++) {
        UITouch *touch = [touchAry objectAtIndex:i];
        if (touch.phase==UITouchPhaseEnded||touch.phase==UITouchPhaseStationary) {
            [availableIds addObject:@(i+1)];
        }
    }
    availablePointId = availableIds.count==0 ? 0 : [[availableIds objectAtIndex:(arc4random() % availableIds.count)] integerValue];
    return availablePointId;
}
@end
