//
//  Stack.m
//  AccessLecture
//
//  Created by Michael Timbrook on 4/20/15.
//
//

#import "Stack.h"

@implementation Stack
{
    NSMutableArray *contents;
}

- (id)init {
    if (self = [super init]) {
        contents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(id)object {
    [contents addObject:object];
}

- (id)pop {
    id returnObject = [contents lastObject];
    if (returnObject) {
        [contents removeLastObject];
    }
    return returnObject;
}

- (NSString *)print
{
    return [contents componentsJoinedByString:@"/"];
}

@end

