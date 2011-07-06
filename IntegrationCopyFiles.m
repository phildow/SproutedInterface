
//
//  IntegrationCopyFiles.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/IntegrationCopyFiles.h>

@implementation IntegrationCopyFiles

- (id) init {
	if ( self = [super initWithWindowNibName:@"IntegrationFileCopy"] ) 
	{
		[self setNoticeText:NSLocalizedString(@"integration copying files",@"")];
		[self retain];
	}
	
	return self;
}

- (void) windowDidLoad {
	
	[[self window] setHidesOnDeactivate:NO];
	//[progress setUsesThreadedAnimation:YES];
	
}

- (void) dealloc
{
	#ifdef __DEBUG__
	NSLog(@"%@ %s",[self className],_cmd);
	#endif
	
	[noticeText release];
	[super dealloc];
}

#pragma mark -

- (NSString*)noticeText
{
	return noticeText;
}

- (void) setNoticeText:(NSString*)aString
{
	if ( noticeText != aString )
	{
		[noticeText release];
		noticeText = [aString copyWithZone:[self zone]];
	}
}

- (void) runNotice {
	
	[[self window] center];
	[[self window] makeKeyAndOrderFront:self];
	
	[progress startAnimation:self];
	
}

- (void) endNotice {
	[progress stopAnimation:self];
	[[self window] close];
}

- (void)windowWillClose:(NSNotification *)aNotification 
{
	[controller unbind:@"contentObject"];
	[controller setContent:nil];
	
	[self autorelease];
}

@end
