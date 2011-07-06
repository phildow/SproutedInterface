//
//  PDOutlineView.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/1/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDOutlineView.h>

@implementation PDOutlineView

- (void)keyDown:(NSEvent *)event 
{ 
	#ifdef __DEBUG__
	NSLog(@"%@ %s - beginning", [self className], _cmd)
	#endif
	
	unsigned int modifierFlags = [event modifierFlags];
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
	
	if ( key == NSLeftArrowFunctionKey && [[self delegate] respondsToSelector:@selector(outlineView:leftNavigationEvent:)] && ( modifierFlags & NSCommandKeyMask ) )
		[[self delegate] outlineView:self leftNavigationEvent:event];
	else if ( key == NSRightArrowFunctionKey && [[self delegate] respondsToSelector:@selector(outlineView:rightNavigationEvent:)] && ( modifierFlags & NSCommandKeyMask ) )
		[[self delegate] outlineView:self rightNavigationEvent:event];
	else
	{
		[super keyDown:event];
	}
	
	#ifdef __DEBUG__
	NSLog(@"%@ %s - ending", [self className], _cmd)
	#endif
}

- (void)cancelOperation:(id)sender
{
   if ([self currentEditor] != nil)
   {
       [self abortEditing];
       
       // We lose focus so re-establish
       [[self window] makeFirstResponder:self];
   }
}

@end
