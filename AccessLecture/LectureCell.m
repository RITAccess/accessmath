//
//  LectureCell.m
//  AccessLecture
//
//  Created by Student on 6/17/13.
//
//

#import "LectureCell.h"

@implementation LectureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       // self.imageView.layer.cornerRadius = 20;
        //self.imageView.layer.borderWidth = 1;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
