//
//  FileMangerViewController.m
//  AccessLecture
//
//  Created by Michael on 1/9/14.
//
//

#import "FileMangerViewController.h"
#import "DocumentPicker.h"
#import "DocumentCreator.h"
#import "FileManager.h"

@interface FileManager ()

- (void)openDocumentForEditing:(NSString *)docName;
+ (NSString *)localDocumentsDirectoryPath;
+ (NSArray *)listContentsOfDirectory:(NSString *)path;
+ (void)createDocumentWithName:(NSString *)name completion:(void (^)(NSError *error, AMLecture *current))completion;

@end

@implementation FileMangerViewController
{
    NSArray *controllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    // TODO check for non existant files and add a new file creation
    NSArray *documents = [FileManager listContentsOfDirectory:[FileManager localDocumentsDirectoryPath]];
    
    NSMutableArray *notes = [NSMutableArray new];
    for (NSString *docName in documents) {
        DocumentPicker *pick =[[DocumentPicker alloc] initWithDocumentName:[[docName componentsSeparatedByString:@"."] objectAtIndex:0]];
        [notes addObject:pick];
    }
    [notes addObject:[DocumentCreator new]];
     controllers = notes;
    [self setViewControllers:@[controllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [controllers indexOfObject:viewController];
    index--;
    if (index >= 0) {
        return controllers[index];
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [controllers indexOfObject:viewController];
    index++;
    if (index < controllers.count) {
        return controllers[index];
    } else {
        return nil;
    }
}

#pragma mark Document calls

- (void)loadDocument:(NSString *)docName
{
    [[FileManager defaultManager] openDocumentForEditing:docName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createDocumentNamed:(NSString *)docName
{
    [FileManager createDocumentWithName:docName completion:^(NSError *error, AMLecture *current) {
         if (error) {
             NSLog(@"%@", error);
         } else {
             [[FileManager defaultManager] openDocumentForEditing:docName];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

@end
