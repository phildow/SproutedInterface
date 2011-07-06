
//
//  CollectionManagerView.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/CollectionManagerView.h>
#import <SproutedInterface/ConditionController.h>

@implementation CollectionManagerView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
		bordered = YES;
	}
	return self;
}

#pragma mark -

- (int) numConditions 
{ 
	return numConditions; 
}

- (void) setNumConditions:(int)num 
{
	numConditions = num;
}

- (BOOL) bordered
{
	return bordered;
}

- (void) setBordered:(BOOL)drawsBorder
{
	bordered = drawsBorder;
}

#pragma mark -

- (BOOL) isFlipped 
{
	return YES; 
}

- (void)drawRect:(NSRect)rect
{
	int i;
	NSRect bds = [self bounds];
	
	for ( i = 0; i < [self numConditions]; i++ ) 
	{
		if ( i % 2 == 0 ) 
		{
			[[NSColor whiteColor] set];
			NSRectFillUsingOperation(NSMakeRect( 0, (kConditionViewHeight*i), bds.size.width, kConditionViewHeight), NSCompositeSourceOver);
		}
		else 
		{
			[[[NSColor controlAlternatingRowBackgroundColors] objectAtIndex:1] set];
			NSRectFillUsingOperation(NSMakeRect( 0, (kConditionViewHeight*i), bds.size.width, kConditionViewHeight), NSCompositeSourceOver);
		}
	}
	
	if ( [self bordered] )
	{
		[[NSColor lightGrayColor] set];
		NSFrameRect(bds);
	}
}

@end
