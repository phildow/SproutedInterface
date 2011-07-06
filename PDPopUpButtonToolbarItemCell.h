
//
//  PDPopUpButtonToolbarItemCell.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface PDPopUpButtonToolbarItemCell : NSPopUpButtonCell 
{
	
	NSSize size;
}

- (NSSize) iconSize;
- (void) setIconSize:(NSSize)aSize;

@end
