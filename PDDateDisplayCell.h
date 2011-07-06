//
//  PDDateDisplayCell.h
//  SproutedInterface
//
//  Created by Philip Dow on 5/31/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDDateDisplayCell : NSTextFieldCell {
	NSDateFormatter *_dayFormatter;
	NSDateFormatter *_timeFormatter;
	
	float widthWas;
	BOOL alreadyJumpedOnNoTime;
	
	BOOL selected;
	BOOL boldsWhenSelected;
}

- (BOOL) isSelected;
- (void) setSelected:(BOOL)isSelected;

- (BOOL) boldsWhenSelected;
- (void) setBoldsWhenSelected:(BOOL)doesBold;

@end
