//
//  LectureNavbar.m
//  AccessLecture
//
//  Created by Michael on 2/13/14.
//
//

#import <Colours/Colours.h>

#import "LectureNavbar.h"
#import "AMOpenButton.h"
#import "ABDrawToggleSwitch.h"

#pragma mark - LectureNavbar

@interface LectureNavbar ()

@end

@implementation LectureNavbar

- (void)layoutSubviews
{
    [super layoutSubviews];
    // Set hight
    self.frame = ({
        CGRect frame = self.frame;
        frame.size.height = 100.0;
        frame;
    });
    // Set color
    self.backgroundColor = [UIColor darkGrayColor];
}

- (void)updateConstraints
{
    [super updateConstraints];
    assert(_openButton);
    assert(_drawingToggle);

//    NSDictionary *views = @{@"open" : _openButton, @"draw" : _drawingToggle, @"title" : _title};
//
//    NSArray *contraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[open]-[draw]-[title]-|" options:(NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom) metrics:nil views:views];
//    [self addConstraints:contraints];

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Back button
    _backButton = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 75, 75)];
        [b setTitle:@"Home" forState:UIControlStateNormal];
        [self addSubview:b];
        b;
    });
    // Set up open button
    _openButton = ({
        AMOpenButton *open = [AMOpenButton buttonWithType:UIButtonTypeCustom];
        open.frame = CGRectMake(115, 20, 75, 75);
        [self addSubview:open];
        open;
    });
    // Set up Drawing toggle
    _drawingToggle = ({
        MKToggleButton *s = [[MKToggleButton alloc] initWithFrame:CGRectMake(210, 20, 75, 75)];
        [s setTitle:@"Draw" forState:UIControlStateNormal];
        [s setTitle:@"Draw" forState:UIControlStateSelected];
        [s setShowsBorder:YES];
        [self addSubview:s];
        s;
    });
    // Set up open button
    _searchButton = ({
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(305, 20, 75, 75)];
        [searchButton setTitle:@"Search" forState:UIControlStateNormal];
        [self addSubview:searchButton];
        searchButton;
    });
}

@end
