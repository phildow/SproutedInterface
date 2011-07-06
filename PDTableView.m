//
//  PDTableView.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/1/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDTableView.h>

@implementation PDTableView

- (void)keyDown:(NSEvent *)event 
{ 
	#ifdef __DEBUG__
	NSLog(@"%@ %s - beginning", [self className], _cmd)
	#endif
		
	unsigned int modifierFlags = [event modifierFlags];
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];

	if ( key == NSLeftArrowFunctionKey && [[self delegate] respondsToSelector:@selector(tableView:leftNavigationEvent:)] && ( modifierFlags & NSCommandKeyMask ) )
		[[self delegate] tableView:self leftNavigationEvent:event];
	else if ( key == NSRightArrowFunctionKey && [[self delegate] respondsToSelector:@selector(tableView:rightNavigationEvent:)] && ( modifierFlags & NSCommandKeyMask ) )
		[[self delegate] tableView:self rightNavigationEvent:event];
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
