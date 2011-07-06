//
//  MUPhotoCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 1/19/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	Or was this originally part of the MUPhotoView package?
//	I subclassed to PDPhotoView and don't recall if I added this as well

#import <SproutedInterface/MUPhotoCell.h>


@implementation MUPhotoCell

- (id)initImageCell:(NSImage *)anImage
{
	if ( self = [super initImageCell:anImage] )
	{
		[self setImageFrameStyle:NSImageFrameNone];
		[self setImageScaling:NSScaleProportionally];
		
		[self setAlignment:NSCenterTextAlignment];
		[self setImageAlignment:NSImageAlignTop];
		
		[self setBezeled:NO];
		[self setBordered:YES];
	}
	
	return self;
}

- (void) dealloc
{
	[imageTitle release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone 
{	
	MUPhotoCell *newObject = [[[self class] allocWithZone:zone] initImageCell:[self image]];
	
	[newObject setTitle:[self title]];
	[newObject setImageFrameStyle:[self imageFrameStyle]];
	[newObject setImageScaling:[self imageScaling]];
	
	[newObject setAlignment:[self alignment]];
	[newObject setImageAlignment:[self imageAlignment]];
	
	[newObject setBezeled:[self isBezeled]];
	[newObject setBordered:[self isBordered]];
			
	return newObject;
}


- (BOOL)isOpaque
{
	return NO;
}

- (NSString*) title
{
	return imageTitle;
}

- (void) setTitle:(NSString*)aString
{
	if ( imageTitle != aString )
	{
		[imageTitle release];
		imageTitle = [aString copyWithZone:[self zone]];
	}
}

#pragma mark -
// #warning should take into account font metrics, etc

- (NSRect)imageRectForBounds:(NSRect)theRect
{
	NSRect adjustedImageFrame = theRect;
	if ( [self title] != nil )
		adjustedImageFrame.size.height -= 30;
		
	return adjustedImageFrame;
}

- (NSRect)titleRectForBounds:(NSRect)theRect
{
	NSRect adjustedTitleFrame = theRect;
	if ( [self objectValue] != nil )
	{
		adjustedTitleFrame.origin.y = adjustedTitleFrame.origin.y + adjustedTitleFrame.size.height - 30;
		adjustedTitleFrame.size.height = 30;
	}
		
	return adjustedTitleFrame;
}

#pragma mark -

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	// that draws the frame and photo interior (drawInterior is called, can't override) in a restricted space, leaving us room for the title
	[super drawWithFrame:[self imageRectForBounds:cellFrame] inView:controlView];
	
	NSMutableParagraphStyle *paragraph = [[[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]] autorelease];
	[paragraph setLineBreakMode:NSLineBreakByWordWrapping];
	[paragraph setAlignment:NSCenterTextAlignment];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont boldSystemFontOfSize:11], NSFontAttributeName,
		[NSColor blackColor], NSForegroundColorAttributeName,
		paragraph, NSParagraphStyleAttributeName, nil];
	
	if ( [self title] != nil )
	{
		NSRect targetTitleRect;
		NSRect originalTitleRect = [self titleRectForBounds:cellFrame];
		NSSize titleSize = [[self title] sizeWithAttributes:attributes];
		
		if ( titleSize.width > originalTitleRect.size.width )
			targetTitleRect = NSMakeRect(	originalTitleRect.origin.x, 
											originalTitleRect.origin.y + (  originalTitleRect.size.height/2 - titleSize.height/2 ),
											originalTitleRect.size.width, 30 );
												
		else
			targetTitleRect = NSMakeRect( originalTitleRect.origin.x + (  originalTitleRect.size.width/2 - titleSize.width/2 ),
											originalTitleRect.origin.y + (  originalTitleRect.size.height/2 - titleSize.height/2 ),
											titleSize.width, 30 );
		
		[[self title] drawInRect:targetTitleRect withAttributes:attributes];
	}
}

@end
