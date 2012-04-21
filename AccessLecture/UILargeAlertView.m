//
//  JKCustomAlert.m
//  CustomAlert
//
//  Created by Joris Kluivers on 4/2/09.
//  Copyright 2009 Tarento Software Solutions & Projects. All rights reserved.
//

#import "UILargeAlertView.h"

#define FRAME_WIDTH 800 // Size of the alert popup
#define FRAME_HEIGHT 480

@implementation UILargeAlertView

@synthesize backgroundImage, alertText;

- (id)initWithText:(NSString *)text fontSize:(int)fontSize {
    if ((self = [super init])) {
		alertTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 550, 390)];
		alertTextLabel.textColor = [UIColor whiteColor];
		alertTextLabel.backgroundColor = [UIColor clearColor];
		alertTextLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [alertTextLabel setNumberOfLines:0];
		[self addSubview:alertTextLabel];
        
        closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [closeButton setFrame:CGRectMake(250, 315, 300, 75)];
        [closeButton setTitle:@"OK" forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize: 36];
        closeButton.titleLabel.shadowOffset = CGSizeMake (1.0, 0.0);
        [closeButton addTarget:self 
                        action:@selector(hide)
              forControlEvents:UIControlEventTouchDown];

        [self addSubview:closeButton];
        
        UIImage* image = [UIImage imageNamed:@"AlertBG.png"];
        self.backgroundImage = image;
		self.alertText = text;
    }
    return self;
}

-(void)setAlertText:(NSString *)text {
	alertTextLabel.text = text;
}

-(NSString *)alertText {
	return alertTextLabel.text;
}


-(void)drawRect:(CGRect)rect {	
	CGSize imageSize = self.backgroundImage.size;
	[self.backgroundImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
}

-(void)layoutSubviews {    
	alertTextLabel.transform = CGAffineTransformIdentity;
	[alertTextLabel sizeToFit];
	
	CGRect textRect = alertTextLabel.frame;
	textRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)) / 2;
	textRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect)) / 2;
	textRect.origin.y -= 30.0;
	alertTextLabel.frame = textRect;
}

-(void)show {
	[super show];
	CGSize imageSize = self.backgroundImage.size;
	self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
}

-(void)hide {
    [self dismissWithClickedButtonIndex:0 animated:YES];
}



@end
