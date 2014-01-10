//
//  Note.h
//  AccessLecture
//
//  Created by Steven Brunwasser on 3/19/12.
//  Modified by Pratik Rasam on 6/26/2013
//  Copyright (c) 2013 Rochester Institute of Technology. All rights reserved.
//
//
//  A note object to hold data pertaining to user created notes.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : UIView <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property CGPoint location;

@end
