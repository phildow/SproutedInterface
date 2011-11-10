//
//  PDTableView.m
//  SproutedInterface
//
//  Created by Philip Dow on 2/1/07.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
