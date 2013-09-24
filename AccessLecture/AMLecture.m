//
//  AMLecture.m
//  AccessLecture
//
//  Created by Michael Timbrook on 9/19/13.
//
//

#import "AMLecture.h"

@implementation AMLecture

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    return [NSData dataWithBytes:"randomjunk" length:10];
}

@end
