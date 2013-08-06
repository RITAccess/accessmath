//
//  AccessLectureRuntime.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 4/21/12.
//  Modified by Pratik Rasam on 6/26/2013
//  Copyright (c) 2012 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccessDocument;

@interface AccessLectureRuntime : NSObject

@property (strong, nonatomic) AccessDocument * currentDocument;

- (id)init;

//
// use this to get a "singleton" instance of the current runtime.
//
+ (AccessLectureRuntime *)defaultRuntime;

//
// Loads the document with the specified url
//
- (void)openDocument:(NSURL *) withURL;

@end
