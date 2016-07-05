//
//  AssignmentTableViewCell.m
//  AccessLecture
//
//  Created by Kimberly Sookoo on 6/14/16.
//
//

#import "AssignmentTableViewCell.h"

@implementation AssignmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(690,8,30, 30);
    //[infoButton addTarget:self action:@selector(infoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:infoButton];
}

-(void)infoButtonSelected {
    //Create a new view that contains the assignment's information in that view
}

@end
