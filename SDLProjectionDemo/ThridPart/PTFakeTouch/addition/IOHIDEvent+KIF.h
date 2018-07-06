//
//  IOHIDEvent+KIF.h
//  testAnything
//
//  Created by PugaTang on 16/4/1.
//  Copyright © 2016年 PugaTang. All rights reserved.
//
#define IOHIDEventFieldBase(type) (type << 16)
#ifdef __LP64__
typedef double IOHIDFloat;
#else
typedef float IOHIDFloat;
#endif
typedef struct __IOHIDEvent * IOHIDEventRef;
typedef UInt32 IOOptionBits;
typedef uint32_t IOHIDDigitizerTransducerType;
typedef uint32_t IOHIDEventField;
IOHIDEventRef kif_IOHIDEventWithTouches(NSArray *touches) CF_RETURNS_RETAINED;

void sg_IOHIDEventAppendEvent(IOHIDEventRef event, IOHIDEventRef childEvent);
void IOHIDEventAppendEvent(IOHIDEventRef event, IOHIDEventRef childEvent);
IOHIDEventRef IOHIDEventCreateDigitizerEvent(CFAllocatorRef allocator, AbsoluteTime timeStamp, IOHIDDigitizerTransducerType type,
                                             uint32_t index, uint32_t identity, uint32_t eventMask, uint32_t buttonMask,
                                             IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat barrelPressure,
                                             Boolean range, Boolean touch, IOOptionBits options);
IOHIDEventRef IOHIDEventCreateDigitizerFingerEventWithQuality(CFAllocatorRef allocator, AbsoluteTime timeStamp,
                                                              uint32_t index, uint32_t identity, uint32_t eventMask,
                                                              IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist,
                                                              IOHIDFloat minorRadius, IOHIDFloat majorRadius, IOHIDFloat quality, IOHIDFloat density, IOHIDFloat irregularity,
                                                              Boolean range, Boolean touch, IOOptionBits options);
IOHIDEventRef sg_IOHIDEventCreateDigitizerEvent(CFAllocatorRef allocator, AbsoluteTime timeStamp, IOHIDDigitizerTransducerType type,
                                             uint32_t index, uint32_t identity, uint32_t eventMask, uint32_t buttonMask,
                                             IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat barrelPressure,
                                             Boolean range, Boolean touch, IOOptionBits options);
IOHIDEventRef sg_IOHIDEventCreateDigitizerFingerEventWithQuality(CFAllocatorRef allocator, AbsoluteTime timeStamp,
                                                              uint32_t index, uint32_t identity, uint32_t eventMask,
                                                              IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist,
                                                              IOHIDFloat minorRadius, IOHIDFloat majorRadius, IOHIDFloat quality, IOHIDFloat density, IOHIDFloat irregularity,
                                                              Boolean range, Boolean touch, IOOptionBits options);
void sg_IOHIDEventSetIntegerValue(IOHIDEventRef event, IOHIDEventField field, int value);
void IOHIDEventSetIntegerValue(IOHIDEventRef event, IOHIDEventField field, int value);

typedef uint32_t IOHIDEventType;

void IOHIDEventSetSenderID(IOHIDEventRef event, uint64_t sender);

enum {
    kIOHIDDigitizerTransducerTypeStylus = 0,
    kIOHIDDigitizerTransducerTypePuck,
    kIOHIDDigitizerTransducerTypeFinger,
    kIOHIDDigitizerTransducerTypeHand
};
enum {
    kIOHIDEventTypeNULL,                    // 0
    kIOHIDEventTypeVendorDefined,
    kIOHIDEventTypeButton,
    kIOHIDEventTypeKeyboard,
    kIOHIDEventTypeTranslation,
    kIOHIDEventTypeRotation,                // 5
    kIOHIDEventTypeScroll,
    kIOHIDEventTypeScale,
    kIOHIDEventTypeZoom,
    kIOHIDEventTypeVelocity,
    kIOHIDEventTypeOrientation,             // 10
    kIOHIDEventTypeDigitizer,
    kIOHIDEventTypeAmbientLightSensor,
    kIOHIDEventTypeAccelerometer,
    kIOHIDEventTypeProximity,
    kIOHIDEventTypeTemperature,             // 15
    kIOHIDEventTypeNavigationSwipe,
    kIOHIDEventTypePointer,
    kIOHIDEventTypeProgress,
    kIOHIDEventTypeMultiAxisPointer,
    kIOHIDEventTypeGyro,                    // 20
    kIOHIDEventTypeCompass,
    kIOHIDEventTypeZoomToggle,
    kIOHIDEventTypeDockSwipe,               // just like kIOHIDEventTypeNavigationSwipe, but intended for consumption by Dock
    kIOHIDEventTypeSymbolicHotKey,
    kIOHIDEventTypePower,                   // 25
    kIOHIDEventTypeLED,
    kIOHIDEventTypeFluidTouchGesture,       // This will eventually superseed Navagation and Dock swipes
    kIOHIDEventTypeBoundaryScroll,
    kIOHIDEventTypeBiometric,
    kIOHIDEventTypeUnicode,                 // 30
    kIOHIDEventTypeAtmosphericPressure,
    kIOHIDEventTypeUndefined,
    kIOHIDEventTypeCount, // This should always be last
    // DEPRECATED:
    kIOHIDEventTypeSwipe = kIOHIDEventTypeNavigationSwipe,
    kIOHIDEventTypeMouse = kIOHIDEventTypePointer
};
enum {
    kIOHIDDigitizerEventRange                               = 0x00000001,
    kIOHIDDigitizerEventTouch                               = 0x00000002,
    kIOHIDDigitizerEventPosition                            = 0x00000004,
    kIOHIDDigitizerEventStop                                = 0x00000008,
    kIOHIDDigitizerEventPeak                                = 0x00000010,
    kIOHIDDigitizerEventIdentity                            = 0x00000020,
    kIOHIDDigitizerEventAttribute                           = 0x00000040,
    kIOHIDDigitizerEventCancel                              = 0x00000080,
    kIOHIDDigitizerEventStart                               = 0x00000100,
    kIOHIDDigitizerEventResting                             = 0x00000200,
    kIOHIDDigitizerEventSwipeUp                             = 0x01000000,
    kIOHIDDigitizerEventSwipeDown                           = 0x02000000,
    kIOHIDDigitizerEventSwipeLeft                           = 0x04000000,
    kIOHIDDigitizerEventSwipeRight                          = 0x08000000,
    kIOHIDDigitizerEventSwipeMask                           = 0xFF000000,
};
enum {
    kIOHIDEventFieldDigitizerX = IOHIDEventFieldBase(kIOHIDEventTypeDigitizer),
    kIOHIDEventFieldDigitizerY,
    kIOHIDEventFieldDigitizerZ,
    kIOHIDEventFieldDigitizerButtonMask,
    kIOHIDEventFieldDigitizerType,
    kIOHIDEventFieldDigitizerIndex,
    kIOHIDEventFieldDigitizerIdentity,
    kIOHIDEventFieldDigitizerEventMask,
    kIOHIDEventFieldDigitizerRange,
    kIOHIDEventFieldDigitizerTouch,
    kIOHIDEventFieldDigitizerPressure,
    kIOHIDEventFieldDigitizerAuxiliaryPressure, //BarrelPressure
    kIOHIDEventFieldDigitizerTwist,
    kIOHIDEventFieldDigitizerTiltX,
    kIOHIDEventFieldDigitizerTiltY,
    kIOHIDEventFieldDigitizerAltitude,
    kIOHIDEventFieldDigitizerAzimuth,
    kIOHIDEventFieldDigitizerQuality,
    kIOHIDEventFieldDigitizerDensity,
    kIOHIDEventFieldDigitizerIrregularity,
    kIOHIDEventFieldDigitizerMajorRadius,
    kIOHIDEventFieldDigitizerMinorRadius,
    kIOHIDEventFieldDigitizerCollection,
    kIOHIDEventFieldDigitizerCollectionChord,
    kIOHIDEventFieldDigitizerChildEventMask,
    kIOHIDEventFieldDigitizerIsDisplayIntegrated,
    kIOHIDEventFieldDigitizerQualityRadiiAccuracy,
};
