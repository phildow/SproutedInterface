//
//  PDAnnotatedTextView.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/23/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDAnnotatedTextView.h>
#import <SproutedInterface/PDAnnotatedRulerView.h>
#import <SproutedInterface/PDAnnotatedTextStorage.h>

@implementation PDAnnotatedTextView

- (void) awakeFromNib
{
	PDAnnotatedTextStorage* ts = [[PDAnnotatedTextStorage alloc] init];
	
	[[self layoutManager] replaceTextStorage:ts]; 
	
	[[self textStorage] setDelegate:self];

	
	NSScrollView* scrollView = [self enclosingScrollView];
	

	
	// *** set up main text View *** //
	//textView setting -- add ruler to textView
	PDAnnotatedRulerView* aNumberingRulerView = 
		[[PDAnnotatedRulerView alloc] initWithScrollView:scrollView
												 orientation:NSVerticalRuler];
	
	[scrollView setVerticalRulerView:aNumberingRulerView ];
	
	//configuration
	[scrollView setHasVerticalRuler:YES];
	[scrollView setHasHorizontalRuler:NO];
	
	[scrollView setRulersVisible:YES];
	
	[aNumberingRulerView release];

}

@end
