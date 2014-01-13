//
//  NSString+TrimmingAdditions.h
//  AccessLecture
//
//  Created by Michael on 1/10/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

@end
