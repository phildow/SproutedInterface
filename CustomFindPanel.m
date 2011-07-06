//
//  CustomFindPanel.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/7/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/CustomFindPanel.h>


@implementation CustomFindPanel

- (BOOL)canBecomeMainWindow
{
	return NO;
}

- (void)keyDown:(NSEvent *)theEvent 
{
	if ( [theEvent keyCode] == 53 ) 
		[self close];
	else
		[super keyDown:theEvent];
}

@end
