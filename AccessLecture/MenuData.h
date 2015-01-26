//
//  MenuData.h
//  AccessLecture
//
//  Created by Michael Timbrook on 1/23/15.
//
//

#import <Foundation/Foundation.h>

@interface MenuData : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *imageName;
@property (nonatomic) SEL action;
@property (nonatomic, weak) id target;

@end