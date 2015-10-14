//
//  NoteViewController.m
//  
//
//  Created by Tina on 6/18/15.
//
//

#import "NoteViewController.h"
#import "ViewContoller.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        CGSize layerSize        = CGSizeMake(768, 200);
        CGPoint layerPosition   = CGPointMake(20, 500);
        CGRect viewFrame = CGRectMake(layerPosition.x, layerPosition.y, layerSize.width-50, layerSize.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:viewFrame];
        _scrollView.contentSize                     = CGSizeMake(120, 2000);
        _scrollView.scrollEnabled                   = YES;
        _scrollView.showsVerticalScrollIndicator  = YES;
        _scrollView.backgroundColor                 = [UIColor grayColor];
    }
    
    return self;
}

- (void) didMoveToView:(SKView *)view{
    if(!self.created){
        [self createScene];
        self.created = YES;
    }
    [self.view addSubview:_scrollView];
}

- (void)willMoveFromView:(SKView *)view
{
    [super willMoveFromView:view];
    
    [_scrollView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(600,700)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
