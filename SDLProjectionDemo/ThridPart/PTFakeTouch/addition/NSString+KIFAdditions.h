//
//  NSString+KIFAdditions.h
//  KIF
//
//  Created by Alex Odawa on 1/28/16.
//
//

#import <Foundation/Foundation.h>

#pragma mark - NSString
@interface NSString (KIFAdditions)

- (BOOL)KIF_isEqualToStringOrAttributedString:(id)aString;

//将Base64编码NSString反编码
- (NSString *)stringBase64Decoded;


@end
