//
//  FSIndex.h
//  AccessLecture
//
//  Created by Michael Timbrook on 3/30/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const FSFileChangeNotification;

@interface AMIndex : NSObject

+ (instancetype)sharedIndex;
- (instancetype)initWithIndex:(NSURL *)pathToIndex;

- (void)addToIndex:(NSURL *)file completion:(void(^)(NSError *error))completion;
- (void)invalidate;

- (NSArray *)objectForKeyedSubscript:(id <NSCopying>)key;
+ (NSString *)localDocumentsDirectoryPath;

//Added below code

@property (nonatomic,assign) NSString *searchCriteria;

@end
