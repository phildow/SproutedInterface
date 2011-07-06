//
//  PDHorizontallyCenteredText.h
//  SproutedInterface
//
//  Created by Philip Dow on 6/19/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDHorizontallyCenteredText : NSTextFieldCell {
	
	BOOL selected;
	BOOL boldsWhenSelected;
}

- (BOOL) isSelected;
- (void) setSelected:(BOOL)isSelected;

- (BOOL) boldsWhenSelected;
- (void) setBoldsWhenSelected:(BOOL)doesBold;

@end
