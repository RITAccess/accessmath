//
//  AccessLectureRuntime.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccessDocument;

@interface AccessLectureRuntime : NSObject

@property (strong, nonatomic) AccessDocument * currentDocument;

- (id)init;

//
// use this to get a "singlton" instance of the current runtime.
//
+ (AccessLectureRuntime *)defaultRuntime;

//
// currently, there is only support for one document.
//
- (void)openDocument;

@end
