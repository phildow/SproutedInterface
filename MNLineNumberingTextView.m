//
//  LineNumberingTextView.m
//  SampleApp
//
//  Created by Masatoshi Nishikata on 06/03/24.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <SproutedInterface/MNLineNumberingTextView.h>


@implementation MNLineNumberingTextView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
		
	


		
    }
    return self;
}

- (void) awakeFromNib
{
	MNLineNumberingTextStorage* ts = [[MNLineNumberingTextStorage alloc] init];
	
	[[self layoutManager] replaceTextStorage:ts]; 
	
	[[self textStorage] setDelegate:self];

	
	NSScrollView* scrollView = [self enclosingScrollView];
	

	
	// *** set up main text View *** //
	//textView setting -- add ruler to textView
	MNLineNumberingRulerView* aNumberingRulerView = 
		[[MNLineNumberingRulerView alloc] initWithScrollView:scrollView
												 orientation:NSVerticalRuler];
	
	[scrollView setVerticalRulerView:aNumberingRulerView ];
	
	//configuration
	[scrollView setHasVerticalRuler:YES];
	[scrollView setHasHorizontalRuler:NO];
	
	[scrollView setRulersVisible:YES];
	
	[aNumberingRulerView release];

}

/*
- (void)awakeFromNib
{

		
	if ([[self superclass] instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib];
	}

}
*/

-(void)dealloc
{
			
	[super dealloc];
}




- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	NSMenuItem* customMenuItem;
	NSMenu* aContextMenu = [super menuForEvent:theEvent];
	
	
	//add separator
	customMenuItem = [NSMenuItem separatorItem];
	[customMenuItem setRepresentedObject:@"MN"];
	[aContextMenu addItem:customMenuItem ];
	
	
	
	// 
	customMenuItem = [[NSMenuItem alloc] initWithTitle:@"Show/Hide Gutter"
												action:@selector(toggleGutterVisiblity) keyEquivalent:@""];
	[customMenuItem setRepresentedObject:@"MN"];
	[aContextMenu addItem:customMenuItem ];
	[customMenuItem release];	
	//
	
	// 
	customMenuItem = [[NSMenuItem alloc] initWithTitle:@"Jump to..."
												action:@selector(jumpTo) keyEquivalent:@""];
	[customMenuItem setRepresentedObject:@"MN"];
	[aContextMenu addItem:customMenuItem ];
	[customMenuItem release];	
	
	
	return aContextMenu;
}

-(void)toggleGutterVisiblity
{
	NSRulerView* rv = [[self enclosingScrollView] verticalRulerView];
	[rv setVisible:![rv isVisible]];	
}

-(void)jumpTo
{
	[[[self enclosingScrollView] verticalRulerView] startSheet];
}

- (void)textStorageDidProcessEditing:(NSNotification *)aNotification
{
	[[[self enclosingScrollView] verticalRulerView] setNeedsDisplay:YES];
}

@end
