//
//  UIEvent+KIFAdditions.h
//  KIF
//
//  Created by Thomas on 3/1/15.
//
//

#import <UIKit/UIKit.h>
#import "FixCategoryBug.h"
KW_FIX_CATEGORY_BUG_H(UIEvent_KIFAdditions)

typedef struct __GSEvent * GSEventRef;
//typedef struct __IOHIDEvent * IOHIDEventRef;

// Exposes methods of UITouchesEvent so that the compiler doesn't complain
@interface UIEvent (KIFAdditionsPrivateHeaders)
- (void)sg_addTouch:(UITouch *)touch forDelayedDelivery:(BOOL)arg2;
- (void)sg_clearTouches;
- (void)sg_setGSEvent:(GSEventRef)event;
//- (void)sg_setHIDEvent:(IOHIDEventRef)event;
- (void)sg_setTimestamp:(NSTimeInterval)timestemp;
@end

@interface UIEvent (KIFAdditions)
- (void)kif_setEventWithTouches:(NSArray *)touches;
@end
