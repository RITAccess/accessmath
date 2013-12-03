//
//  Favorites.h
//  AccessLecture
//
//  Created by Michael Timbrook on 8/9/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorites : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * hostname;

@end
