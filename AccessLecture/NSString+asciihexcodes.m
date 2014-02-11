//
//  NSString+asciihexcodes.m
//  AccessLecture
//
//  Created by Michael on 2/4/14.
//
//

#import "NSString+asciihexcodes.h"

@implementation NSString (asciihexcodes)

+ stringWithASCIIHexCode:(NSString *)code
{
    if (code.length == 6) {
        NSString *hexcode = [code substringWithRange:NSMakeRange(3, 2)];
        return [NSString stringFromHexString:hexcode];
    } else {
        return nil;
    }
}

+ (NSString *)stringFromHexString:(NSString *)hexString {
    // The hex codes should all be two characters.
    if (([hexString length] % 2) != 0)
        return nil;
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = 0; i < [hexString length]; i += 2) {
        NSString *hex = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSInteger decimalValue = 0;
        sscanf([hex UTF8String], "%x", &decimalValue);
        [string appendFormat:@"%c", decimalValue];
    }
    return string;
}

@end
