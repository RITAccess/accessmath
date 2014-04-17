//
//  DocumentPicker.h
//  AccessLecture
//
//  Created by Michael on 1/9/14.
//
//

#import <UIKit/UIKit.h>
#import "FileManager.h"

@interface DocumentPicker : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *noteTitle;

- (instancetype)initWithDocumentName:(NSString *)name;

@end
