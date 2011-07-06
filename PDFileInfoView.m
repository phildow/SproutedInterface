//
//  PDFileInfoView.m
//  SproutedInterface
//
//  Created by Philip Dow on 6/17/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDFileInfoView.h>
#import <SproutedUtilities/NSImage_PDCategories.h>
#import <SproutedUtilities/NSBezierPath_AMAdditons.h>

#import <QuartzCore/QuartzCore.h>

#define  kFilterOffset 14

@implementation PDFileInfoView

static NSString* NoNullString( NSString *aString ) 
{
	return ( aString == nil ? [NSString string] : aString );
}

- (id)initWithFrame:(NSRect)frameRect
{
	if ( self = [super initWithFrame:frameRect] )
	{
		cell = [[NSImageCell alloc] initImageCell:nil];
		[cell setImageFrameStyle:NSImageFrameNone];
		
		viewAlignment = PDFileInfoAlignLeft;
	}
	return self;
}

- (void) dealloc
{
	[url release];
	[cell release];
	[super dealloc];
}

#pragma mark -

- (BOOL) isFlipped
{
	return YES;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	
	[super drawRect:rect];
	
	if ( [self url] == nil )
		return;
	
	NSRect bds = [self bounds];
	NSSize cellSize = NSMakeSize(128,128);
	
	NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[[self url] path]];
	[icon setSize:NSMakeSize(128,128)];
	
	/*
	CIFilter *perspectiveTransform = [CIFilter filterWithName:@"CIPerspectiveTransform"];
	[perspectiveTransform setDefaults];
	
	CIVector *trVector = [CIVector vectorWithX:128-kFilterOffset Y:128-kFilterOffset];
	CIVector *brVector = [CIVector vectorWithX:128-kFilterOffset Y:kFilterOffset];
	CIVector *tlVector = [CIVector vectorWithX:0 Y:128];
	CIVector *blVector = [CIVector vectorWithX:0 Y:0];
	
	[perspectiveTransform setValue:[NSImage CIImageFromImage:icon] forKey:@"inputImage"];
	[perspectiveTransform setValue:trVector forKey:@"inputTopRight"];
	[perspectiveTransform setValue:brVector forKey:@"inputBottomRight"];
	[perspectiveTransform setValue:tlVector forKey:@"inputTopLeft"];
	[perspectiveTransform setValue:blVector forKey:@"inputBottomLeft"];
	
	icon = [NSImage imageFromCIImage: [perspectiveTransform valueForKey:@"outputImage"] ];
	
	NSImage *reflectedIcon = [icon reflectedImage:0.33];
	*/
	
	[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] set];
	NSRectFillUsingOperation(rect, NSCompositeSourceOver);
	
	/*
	NSRect iconBoundary;
	
	if ( viewAlignment == PDFileInfoAlignLeft )
		iconBoundary = NSMakeRect( 5, bds.size.height - 5, cellSize.width+10, cellSize.height+10 );
	else if ( viewAlignment == PDFileInfoAlignRight )
		iconBoundary = NSMakeRect( bds.size.width - cellSize.width - 15, bds.size.height - 5, cellSize.width+10, cellSize.height+10 );
	*/
	
	NSRect iconRect;
	//NSRect reflectedRect;
	
	if ( viewAlignment == PDFileInfoAlignLeft )
		iconRect = NSMakeRect( 10, /*bds.size.height - cellSize.height - 30*/ 30, cellSize.width, cellSize.height );
	else if ( viewAlignment == PDFileInfoAlignRight )
		iconRect = NSMakeRect( bds.size.width - cellSize.width - 10, /*bds.size.height - cellSize.height - 30*/ 30, cellSize.width, cellSize.height );
	
	//reflectedRect = iconRect;
	//reflectedRect.origin.y -= 128;
	
	[cell setObjectValue:icon];
	[cell setImageAlignment:NSImageAlignBottom];
	[cell drawWithFrame:iconRect inView:self];
	
	//[cell setObjectValue:reflectedIcon];
	//[cell setImageAlignment:NSImageAlignTop];
	//[cell drawWithFrame:reflectedRect inView:self];
	
	// draw the information for the resource
	[self _drawInfoForFile];
	
	// set up a cursor rect
}

- (void) _drawInfoForFile
{
	unsigned long long kBytesInKilobyte = 1024;
	unsigned long long kBytesInMegabyte = 1048576;
	unsigned long long kBytesInGigabyte = 1073741824;
	
	NSString *path = [[self url] path];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	FSRef fsRef;
	FSCatalogInfo catInfo;
	// #warning returns 0 when the file is a package/directory
	
	if ( ![fm fileExistsAtPath:path] )
	{
		return;
	}
	
	NSSize cellSize = NSMakeSize(128,128);
	NSSize stringSize;
	NSRect stringRect;
	unsigned int originaXOffset= ( viewAlignment == PDFileInfoAlignLeft ? 5*2 + cellSize.width + 10 : 5*2 );
	
	NSBundle *myBundle = [NSBundle bundleWithIdentifier:@"com.sprouted.interface"];
	
	NSMutableParagraphStyle *titleParagraph = [[[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]] autorelease];
	[titleParagraph setLineBreakMode:NSLineBreakByTruncatingMiddle];
	
	NSShadow *textShadow = [[[NSShadow alloc] init] autorelease];
	
	[textShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.96 alpha:0.96]];
	[textShadow setShadowOffset:NSMakeSize(0,-1)];
	
	NSDictionary *titleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont systemFontOfSize:11], NSFontAttributeName,
		[NSColor blackColor], NSForegroundColorAttributeName,
		textShadow, NSShadowAttributeName,
		titleParagraph, NSParagraphStyleAttributeName, nil];
	
	NSDictionary *labelAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont boldSystemFontOfSize:11], NSFontAttributeName,
		[NSColor colorWithCalibratedWhite:0.4 alpha:1.0], NSForegroundColorAttributeName, 
		textShadow, NSShadowAttributeName, nil];
	
	NSDictionary *propertyAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont systemFontOfSize:11], NSFontAttributeName,
		[NSColor blackColor], NSForegroundColorAttributeName, 
		titleParagraph, NSParagraphStyleAttributeName, 
		textShadow, NSShadowAttributeName, nil];
	
	MDItemRef mdItem = MDItemCreate(NULL,(CFStringRef)path);
	
	// derive an icon for the file based on the unique file system file number
	NSDictionary *fileAttributes = [fm fileAttributesAtPath:path traverseLink:NO];
	
	
	NSRect bds = [self bounds];
	NSRect iconRect;
	NSRect infoRect;
	NSRect infoReflectionRect;
	
	NSSize lwTitle, lwKind, lwSize, lwCreated, lwModified, lwLastOpened, lwMax;
	
	lwTitle = NSMakeSize(0, 0);
	lwKind = NSMakeSize(0, 0);
	lwSize = NSMakeSize(0, 0);
	lwCreated = NSMakeSize(0, 0);
	lwModified = NSMakeSize(0, 0);
	lwLastOpened = NSMakeSize(0, 0);
	lwMax = NSMakeSize(0, 0);

	if ( viewAlignment == PDFileInfoAlignLeft )
		iconRect = NSMakeRect( 10, bds.size.height - cellSize.height - 30, cellSize.width, cellSize.height + 20 );
	else if ( viewAlignment == PDFileInfoAlignRight )
		iconRect = NSMakeRect( bds.size.width - cellSize.width - 10, bds.size.height - cellSize.height - 30, cellSize.width, cellSize.height + 20 );
	
	infoRect = iconRect;
	infoRect.origin.x = originaXOffset;
	infoRect.size.width = bds.size.width - originaXOffset;
	
	infoReflectionRect = infoRect;
	infoReflectionRect.origin.y -= 152;
	
	//unsigned int xOffset = 0, yOffset = infoRect.size.height - 20;
	unsigned int xOffset = originaXOffset, yOffset = 50; // 30 for the image cell, 50 is a bit arbitrary
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	// only draw if there is room for the information
	if ( infoRect.size.width > 1 )
	{
		
		// first calculate all the label widths
		
		// labels
		NSString *titleLabel = NSLocalizedStringFromTableInBundle(@"mditem title name", @"FileInfo", myBundle, @"");
		NSString *typeLabel = NSLocalizedStringFromTableInBundle(@"mditem kind name", @"FileInfo", myBundle, @"");
		NSString *sizeLabel = NSLocalizedStringFromTableInBundle(@"mditem size name", @"FileInfo", myBundle, @"");
		NSString *dateLabel = NSLocalizedStringFromTableInBundle(@"mditem created name", @"FileInfo", myBundle, @"");
		NSString *dateModifiedLabel = NSLocalizedStringFromTableInBundle(@"mditem modified name", @"FileInfo", myBundle, @"");
		NSString *lastOpenedLabel = NSLocalizedStringFromTableInBundle(@"mditem lastopened name", @"FileInfo", myBundle, @"");
		
		// values
		NSString *displayName = /*[fm displayNameAtPath:path];*/ [[path lastPathComponent] stringByDeletingPathExtension];
		
		NSDate *dateCreated = [fileAttributes valueForKey:NSFileCreationDate];
		NSString *dateCreatedAsString = nil;
		if ( dateCreated != nil ) dateCreatedAsString = NoNullString([dateFormatter stringFromDate:dateCreated]);
		
		NSDate *dateModified = [fileAttributes valueForKey:NSFileModificationDate];
		NSString *dateModifiedAsString = nil;
		if ( dateModified != nil )dateModifiedAsString = NoNullString([dateFormatter stringFromDate:dateModified]);
		
		NSString *typeDescription = nil;
		NSString *lastOpenedAsString = nil;
		
		if ( mdItem != NULL ) 
		{
			typeDescription = [(NSString*)MDItemCopyAttribute(mdItem,(CFStringRef)kMDItemKind) autorelease];
			
			NSDate *lastOpened = (NSDate*)[(NSString*)MDItemCopyAttribute(mdItem,(CFStringRef)kMDItemLastUsedDate) autorelease];
			if ( lastOpened != nil ) lastOpenedAsString = NoNullString([dateFormatter stringFromDate:lastOpened]);
			
			CFRelease(mdItem);
			mdItem = NULL;
		}
		
		// actually calculate the sizes
		
		if ( titleLabel != nil ) lwTitle = [titleLabel sizeWithAttributes:labelAttrs];
		if ( lwTitle.width > lwMax.width ) lwMax.width = lwTitle.width;

		if ( typeLabel != nil ) lwKind = [typeLabel sizeWithAttributes:labelAttrs];
		if ( lwKind.width > lwMax.width ) lwMax.width = lwKind.width;
		
		if ( sizeLabel != nil ) lwSize = [sizeLabel sizeWithAttributes:labelAttrs];
		if ( lwSize.width > lwMax.width ) lwMax.width = lwSize.width;

		if ( dateLabel != nil ) lwCreated = [dateLabel sizeWithAttributes:labelAttrs];
		if ( lwCreated.width > lwMax.width ) lwMax.width = lwCreated.width;
		
		if ( dateModifiedLabel != nil ) lwModified = [dateModifiedLabel sizeWithAttributes:labelAttrs];
		if ( lwModified.width > lwMax.width ) lwMax.width = lwModified.width;
		
		if ( lastOpenedLabel != nil ) lwLastOpened = [lastOpenedLabel sizeWithAttributes:labelAttrs];
		if ( lwLastOpened.width > lwMax.width ) lwMax.width = lwLastOpened.width;
		
		// max widths
		unsigned int maxWidth = [self bounds].size.width - ( xOffset + lwMax.width + 8 + 20 );
		float greatestWidth = 0;
		
		// do the drawing
		
		// display name
		if ( displayName != nil )
		{
			// label
			stringRect = NSMakeRect( xOffset + ( lwMax.width - lwTitle.width), yOffset, lwTitle.width, lwTitle.height );
			[titleLabel drawInRect:stringRect withAttributes:labelAttrs];
			
			if ( xOffset + lwTitle.width > greatestWidth )
				greatestWidth = xOffset + lwTitle.width;
			
			xOffset += lwMax.width;
			xOffset += 8;
			
			// value
			stringSize = [displayName sizeWithAttributes:titleAttrs];
			[displayName drawInRect:NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height ) withAttributes:titleAttrs];
			
			if ( xOffset + stringSize.width > greatestWidth )
				greatestWidth = xOffset + stringSize.width;
		
			yOffset += stringSize.height;
			xOffset = originaXOffset;
		}
		
		// file type
		if ( typeLabel != nil && typeDescription != nil )
		{
			// label
			stringRect = NSMakeRect( xOffset + ( lwMax.width - lwKind.width), yOffset, lwKind.width, lwKind.height );
			[typeLabel drawInRect:stringRect withAttributes:labelAttrs];
			
			if ( xOffset + lwKind.width > greatestWidth )
				greatestWidth = xOffset + lwKind.width;
			
			xOffset += lwMax.width;
			xOffset += 8;
			
			// value
			stringSize = [typeDescription sizeWithAttributes:propertyAttrs];
			stringRect = NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height );
			[typeDescription drawInRect:stringRect withAttributes:propertyAttrs];
			
			if ( xOffset + stringSize.width > greatestWidth )
				greatestWidth = xOffset + stringSize.width;

			yOffset += stringSize.height;
			xOffset = originaXOffset;
		} // file type

		// file size	
		if ( FSPathMakeRef((const UInt8 *)[path UTF8String] ,&fsRef,NULL) == noErr && 
					FSGetCatalogInfo(&fsRef,kFSCatInfoGettableInfo,&catInfo,NULL,NULL,NULL) == noErr ) 
		{
			// is it necessary to add the resource size?
			UInt64 file_size = catInfo.dataPhysicalSize + catInfo.rsrcPhysicalSize;
			NSString *fileSizeAsString;
			
			if ( file_size != 0 )
			{
				if ( file_size / kBytesInGigabyte > 1 ) 
				{
					NSNumber *gigabytes = [NSNumber numberWithInt:(file_size / kBytesInGigabyte)];
					fileSizeAsString = NoNullString( [[gigabytes stringValue] stringByAppendingString:
					NSLocalizedStringFromTableInBundle(@"mditem size gb", @"FileInfo", myBundle, @"")] );
				}
				else 
				{
					if ( file_size / kBytesInMegabyte > 1 ) 
					{
						NSNumber *megabytes = [NSNumber numberWithInt:(file_size / kBytesInMegabyte)];
						fileSizeAsString = NoNullString( [[megabytes stringValue] stringByAppendingString:
						NSLocalizedStringFromTableInBundle(@"mditem size mb", @"FileInfo", myBundle, @"")] );
					}
					else 
					{
						NSNumber *kilobytes = [NSNumber numberWithInt:(file_size / kBytesInKilobyte)];
						fileSizeAsString = NoNullString( [[kilobytes stringValue] stringByAppendingString:
						NSLocalizedStringFromTableInBundle(@"mditem size kb", @"FileInfo", myBundle, @"")] );
					}
				}
				


				if ( sizeLabel != nil && fileSizeAsString != nil )
				{
					// label
					stringRect = NSMakeRect( xOffset + ( lwMax.width - lwSize.width), yOffset, lwSize.width, lwSize.height );
					[sizeLabel drawInRect:stringRect withAttributes:labelAttrs];
					
					if ( xOffset + lwSize.width > greatestWidth )
						greatestWidth = xOffset + lwSize.width;
					
					xOffset += lwMax.width;
					xOffset += 8;					
					
					// value
					stringSize = [fileSizeAsString sizeWithAttributes:propertyAttrs];
					stringRect = NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height );
					[fileSizeAsString drawInRect:stringRect withAttributes:propertyAttrs];
					
					if ( xOffset + stringSize.width > greatestWidth )
						greatestWidth = xOffset + stringSize.width;
					
					yOffset += stringSize.height;
					xOffset = originaXOffset;
				}
			}
		} // file size

		
		// date created
		if ( dateLabel != nil && dateCreatedAsString != nil )
		{
			// label
			stringRect = NSMakeRect( xOffset + ( lwMax.width - lwCreated.width), yOffset, lwCreated.width, lwCreated.height );
			[dateLabel drawInRect:stringRect withAttributes:labelAttrs];
			
			if ( xOffset + lwCreated.width > greatestWidth )
				greatestWidth = xOffset + lwCreated.width;
			
			xOffset += lwMax.width;
			xOffset += 8;
			
			// value
			stringSize = [dateCreatedAsString sizeWithAttributes:propertyAttrs];
			stringRect = NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height );
			[dateCreatedAsString drawInRect:stringRect withAttributes:propertyAttrs];
			
			if ( xOffset + stringSize.width > greatestWidth )
				greatestWidth = xOffset + stringSize.width;
			
			yOffset += stringSize.height;
			xOffset = originaXOffset;
		} // date created

		
		// date modified
		if ( dateModifiedLabel != nil && dateModifiedAsString != nil )
		{
			// label
			stringRect = NSMakeRect( xOffset + ( lwMax.width - lwModified.width), yOffset, lwModified.width, lwModified.height );
			[dateModifiedLabel drawInRect:stringRect withAttributes:labelAttrs];
			
			if ( xOffset + lwModified.width > greatestWidth )
				greatestWidth = xOffset + lwModified.width;
			
			xOffset += lwMax.width;
			xOffset += 8;
						
			// value
			stringSize = [dateModifiedAsString sizeWithAttributes:propertyAttrs];
			stringRect = NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height );
			[dateModifiedAsString drawInRect:stringRect withAttributes:propertyAttrs];
			
			if ( xOffset + stringSize.width > greatestWidth )
				greatestWidth = xOffset + stringSize.width;
			
			yOffset += stringSize.height;
			xOffset = originaXOffset;
		} // date modified

		
		// last opened
		if ( lastOpenedLabel != nil && lastOpenedAsString != nil )
		{
			// label
			stringRect = NSMakeRect( xOffset + ( lwMax.width - lwLastOpened.width), yOffset, lwLastOpened.width, lwLastOpened.height );
			[lastOpenedLabel drawInRect:stringRect withAttributes:labelAttrs];
			
			if ( xOffset + lwLastOpened.width > greatestWidth )
				greatestWidth = xOffset + lwLastOpened.width;
			
			xOffset += lwMax.width;
			xOffset += 8;
			
			// value
			stringSize = [lastOpenedAsString sizeWithAttributes:propertyAttrs];
			stringRect = NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height );
			[lastOpenedAsString drawInRect:stringRect withAttributes:propertyAttrs];
			
			if ( xOffset + stringSize.width > greatestWidth )
				greatestWidth = xOffset + stringSize.width;
			
			yOffset += stringSize.height;
			xOffset = originaXOffset;
		} // last opened
	}
}


/*

- (void) _drawInfoForFile
{
	unsigned long long kBytesInKilobyte = 1024;
	unsigned long long kBytesInMegabyte = 1048576;
	unsigned long long kBytesInGigabyte = 1073741824;
	
	NSString *path = [[self url] path];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	FSRef fsRef;
	FSCatalogInfo catInfo;
	// #warning returns 0 when the file is a package/directory
	
	if ( ![fm fileExistsAtPath:path] )
	{
		return;
	}
	
	NSSize cellSize = NSMakeSize(128,128);
	NSSize stringSize;
	//NSRect stringRect;
	unsigned int originaXOffset= ( viewAlignment == PDFileInfoAlignLeft ? 5*2 + cellSize.width + 10 : 5*2 );
	
	//unsigned int xOffset = originaXOffset, yOffset = 20;
	//unsigned int xOffset = 0, yOffset = [self bounds].size.height - 20;
	unsigned int maxWidth = [self bounds].size.width - ( 5*2 + cellSize.width + 10*2 );
	float greatestWidth = 0;
	
	NSMutableParagraphStyle *titleParagraph = [[[NSParagraphStyle defaultParagraphStyle] mutableCopyWithZone:[self zone]] autorelease];
	[titleParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
	
	NSShadow *textShadow = [[[NSShadow alloc] init] autorelease];
	
	[textShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.96 alpha:0.96]];
	[textShadow setShadowOffset:NSMakeSize(0,-1)];
	
	NSDictionary *titleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont boldSystemFontOfSize:13], NSFontAttributeName,
		[NSColor blackColor], NSForegroundColorAttributeName,
		textShadow, NSShadowAttributeName,
		titleParagraph, NSParagraphStyleAttributeName, nil];
	
	NSDictionary *labelAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont boldSystemFontOfSize:13], NSFontAttributeName,
		[NSColor blackColor], NSForegroundColorAttributeName, 
		textShadow, NSShadowAttributeName, nil];
	
	NSDictionary *propertyAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont systemFontOfSize:13], NSFontAttributeName,
		[NSColor blackColor], NSForegroundColorAttributeName, 
		titleParagraph, NSParagraphStyleAttributeName, 
		textShadow, NSShadowAttributeName, nil];
	
	MDItemRef mdItem = MDItemCreate(NULL,(CFStringRef)path);
	
	// derive an icon for the file based on the unique file system file number
	NSDictionary *fileAttributes = [fm fileAttributesAtPath:path traverseLink:NO];
	
	
	NSRect bds = [self bounds];
	NSRect iconRect;
	NSRect infoRect;
	NSRect infoReflectionRect;

	if ( viewAlignment == PDFileInfoAlignLeft )
		iconRect = NSMakeRect( 10, bds.size.height - cellSize.height -10, cellSize.width, cellSize.height );
	else if ( viewAlignment == PDFileInfoAlignRight )
		iconRect = NSMakeRect( bds.size.width - cellSize.width - 10, bds.size.height - cellSize.height -10, cellSize.width, cellSize.height );
	
	infoRect = iconRect;
	infoRect.origin.x = originaXOffset;
	infoRect.size.width = bds.size.width - originaXOffset;
	
	infoReflectionRect = infoRect;
	infoReflectionRect.origin.y -= 132;
	
	unsigned int xOffset = 0, yOffset = infoRect.size.height - 20;
	
	// only draw if there is room for the information
	if ( infoRect.size.width > 1 )
	{
	
		NSImage *textImage = [[[NSImage alloc] initWithSize:infoRect.size] autorelease];
		
		[textImage lockFocus];
		
		// draw the header
		NSString *displayName = [fm displayNameAtPath:path];
		if ( displayName != nil )
		{
			stringSize = [displayName sizeWithAttributes:titleAttrs];
			[displayName drawInRect:NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height ) withAttributes:titleAttrs];
			
			if ( xOffset + stringSize.width > greatestWidth )
				greatestWidth = xOffset + stringSize.width;
			
			//yOffset += stringSize.height;
			//yOffset += 14;
			yOffset -= stringSize.height;
			yOffset -= 14;
		}
		
		// file type
		if ( mdItem != NULL ) 
		{
			NSString *typeLabel = NSLocalizedString(@"mditem kind name",@"");
			NSString *typeDescription = [(NSString*)MDItemCopyAttribute(mdItem,(CFStringRef)kMDItemKind) autorelease];
			
			if ( typeLabel != nil && typeDescription != nil )
			{
				stringSize = [typeLabel sizeWithAttributes:labelAttrs];
				[typeLabel drawInRect:NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height ) withAttributes:labelAttrs];
				
				if ( xOffset + stringSize.width > greatestWidth )
					greatestWidth = xOffset + stringSize.width;
				
				xOffset += ( stringSize.width < maxWidth ? stringSize.width : maxWidth );
				xOffset += 8;
				
				stringSize = [typeDescription sizeWithAttributes:propertyAttrs];
				[typeDescription drawInRect:NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height ) withAttributes:propertyAttrs];
				
				if ( xOffset + stringSize.width > greatestWidth )
					greatestWidth = xOffset + stringSize.width;
				
				//yOffset += stringSize.height;
				//xOffset = originaXOffset;
				yOffset -= stringSize.height;
				xOffset = 0;
			}
		}
		
		// file size	
		if ( FSPathMakeRef((const UInt8 *)[path UTF8String] ,&fsRef,NULL) == noErr && 
				FSGetCatalogInfo(&fsRef,kFSCatInfoGettableInfo,&catInfo,NULL,NULL,NULL) == noErr ) 
		{
			
			// is it necessary to add the resource size?
			UInt64 file_size = catInfo.dataPhysicalSize + catInfo.rsrcPhysicalSize;
			NSString *fileSizeAsString;
			
			if ( file_size != 0 )
			{
				if ( file_size / kBytesInGigabyte > 1 ) 
				{
					NSNumber *gigabytes = [NSNumber numberWithInt:(file_size / kBytesInGigabyte)];
					fileSizeAsString = NoNullString([[gigabytes stringValue] stringByAppendingString:NSLocalizedString(@"mditem size gb",@"")]);
				}
				else 
				{
					if ( file_size / kBytesInMegabyte > 1 ) 
					{
						NSNumber *megabytes = [NSNumber numberWithInt:(file_size / kBytesInMegabyte)];
						fileSizeAsString = NoNullString([[megabytes stringValue] stringByAppendingString:NSLocalizedString(@"mditem size mb",@"")]);
					}
					else 
					{
						NSNumber *kilobytes = [NSNumber numberWithInt:(file_size / kBytesInKilobyte)];
						fileSizeAsString = NoNullString([[kilobytes stringValue] stringByAppendingString:NSLocalizedString(@"mditem size kb",@"")]);
					}
				}
				
				NSString *sizeLabel = NSLocalizedString(@"mditem size name",@"");
				
				if ( sizeLabel != nil && fileSizeAsString != nil )
				{
					stringSize = [sizeLabel sizeWithAttributes:labelAttrs];
					[sizeLabel drawInRect:NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height ) withAttributes:labelAttrs];
					
					if ( xOffset + stringSize.width > greatestWidth )
						greatestWidth = xOffset + stringSize.width;
					
					xOffset += ( stringSize.width < maxWidth ? stringSize.width : maxWidth );
					xOffset += 8;
					
					stringSize = [fileSizeAsString sizeWithAttributes:propertyAttrs];
					[fileSizeAsString drawInRect:NSMakeRect( xOffset, yOffset, ( stringSize.width < maxWidth ? stringSize.width : maxWidth ), stringSize.height ) withAttributes:propertyAttrs];
					
					if ( xOffset + stringSize.width > greatestWidth )
						greatestWidth = xOffset + stringSize.width;
					
					//yOffset += stringSize.height;
					//xOffset = originaXOffset;
					yOffset -= stringSize.height;
					xOffset = 0;
				}
			}
		}
		
		// date created and modified;
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		// date created
		NSDate *dateCreated = [fileAttributes valueForKey:NSFileCreationDate];
		if ( dateCreated != nil )
		{
			NSString *dateLabel = NSLocalizedString(@"mditem created name",@"");
			NSString *dateCreatedAsString = NoNullString([dateFormatter stringFromDate:dateCreated]);
			
			if ( dateLabel != nil && dateCreatedAsString != nil )
			{
				stringSize = [dateLabel sizeWithAttributes:labelAttrs];
				[dateLabel drawInRect:NSMakeRect( xOffset, yOffset, stringSize.width, stringSize.height ) withAttributes:labelAttrs];
				
				if ( xOffset + stringSize.width > greatestWidth )
					greatestWidth = xOffset + stringSize.width;
				
				xOffset += stringSize.width;
				xOffset += 8;
				
				stringSize = [dateCreatedAsString sizeWithAttributes:propertyAttrs];
				[dateCreatedAsString drawInRect:NSMakeRect( xOffset, yOffset, stringSize.width, stringSize.height ) withAttributes:propertyAttrs];
				
				if ( xOffset + stringSize.width > greatestWidth )
					greatestWidth = xOffset + stringSize.width;
				
				//yOffset += stringSize.height;
				//xOffset = originaXOffset;
				yOffset -= stringSize.height;
				xOffset = 0;
			}
		}
		
		// date modified
		NSDate *dateModified = [fileAttributes valueForKey:NSFileModificationDate];
		if ( dateModified != nil )
		{
			NSString *dateModifiedLabel = NSLocalizedString(@"mditem modified name",@"");
			NSString *dateModifiedAsString = NoNullString([dateFormatter stringFromDate:dateModified]);
			
			if ( dateModifiedLabel != nil && dateModifiedAsString != nil )
			{
				stringSize = [dateModifiedLabel sizeWithAttributes:labelAttrs];
				[dateModifiedLabel drawInRect:NSMakeRect( xOffset, yOffset, stringSize.width, stringSize.height ) withAttributes:labelAttrs];
				
				if ( xOffset + stringSize.width > greatestWidth )
					greatestWidth = xOffset + stringSize.width;
				
				xOffset += stringSize.width;
				xOffset += 8;
				
				stringSize = [dateModifiedAsString sizeWithAttributes:propertyAttrs];
				[dateModifiedAsString drawInRect:NSMakeRect( xOffset, yOffset, stringSize.width, stringSize.height ) withAttributes:propertyAttrs];
				
				if ( xOffset + stringSize.width > greatestWidth )
					greatestWidth = xOffset + stringSize.width;
				
				//yOffset += stringSize.height;
				//xOffset = originaXOffset;
				yOffset -= stringSize.height;
				xOffset = 0;
			}
		}
		
		// last opened
		if ( mdItem != NULL ) 
		{
			NSDate *lastOpened = (NSDate*)[(NSString*)MDItemCopyAttribute(mdItem,(CFStringRef)kMDItemLastUsedDate) autorelease];
			if ( lastOpened != nil )
			{
				NSString *lastOpenedLabel = NSLocalizedString(@"mditem lastopened name",@"");
				NSString *lastOpenedAsString = NoNullString([dateFormatter stringFromDate:lastOpened]);
				
				if ( lastOpenedLabel != nil && lastOpenedAsString != nil )
				{
					stringSize = [lastOpenedLabel sizeWithAttributes:labelAttrs];
					[lastOpenedLabel drawInRect:NSMakeRect( xOffset, yOffset, stringSize.width, stringSize.height ) withAttributes:labelAttrs];
					
					if ( xOffset + stringSize.width > greatestWidth )
						greatestWidth = xOffset + stringSize.width;
					
					xOffset += stringSize.width;
					xOffset += 8;
					
					stringSize = [lastOpenedAsString sizeWithAttributes:propertyAttrs];
					[lastOpenedAsString drawInRect:NSMakeRect( xOffset, yOffset, stringSize.width, stringSize.height ) withAttributes:propertyAttrs];
					
					if ( xOffset + stringSize.width > greatestWidth )
						greatestWidth = xOffset + stringSize.width;
					
					//yOffset += stringSize.height;
					//xOffset = originaXOffset;
					yOffset -= stringSize.height;
					xOffset = 0;
				}
			}
			
			// clean up
			CFRelease(mdItem);
		
		}
		
		[textImage unlockFocus];
		[textImage drawInRect:infoRect fromRect:NSMakeRect(0,0,infoRect.size.width,infoRect.size.height) 
		operation:NSCompositeSourceOver fraction:1.0];
		
		// draw the reflection

		NSImage *reflectedText = [NSImage reflectedImage:textImage amountReflected:0.33];
		
		[cell setImageAlignment:NSImageAlignTop];
		[cell setObjectValue:reflectedText];
		[cell drawInteriorWithFrame:infoReflectionRect inView:self];
	}
}

*/

#pragma mark -

- (void)resetCursorRects
{
	NSRect iconRect;
	
	NSRect bds = [self bounds];
	NSSize cellSize = NSMakeSize(128,128);
	
	if ( viewAlignment == PDFileInfoAlignLeft )
		iconRect = NSMakeRect( 10, bds.size.height - cellSize.height - 30, cellSize.width, cellSize.height );
	else if ( viewAlignment == PDFileInfoAlignRight )
		iconRect = NSMakeRect( bds.size.width - cellSize.width - 10, bds.size.height - cellSize.height - 30, cellSize.width, cellSize.height );
		
	[self addCursorRect:iconRect cursor:[NSCursor pointingHandCursor]];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	NSRect iconRect;
	
	NSRect bds = [self bounds];
	NSSize cellSize = NSMakeSize(128,128);
	
	if ( viewAlignment == PDFileInfoAlignLeft )
		iconRect = NSMakeRect( 10, bds.size.height - cellSize.height - 30, cellSize.width, cellSize.height );
	else if ( viewAlignment == PDFileInfoAlignRight )
		iconRect = NSMakeRect( bds.size.width - cellSize.width - 10, bds.size.height - cellSize.height - 30, cellSize.width, cellSize.height );
			
	if ( NSMouseInRect(curPoint,iconRect,[self isFlipped]) )
	{
		if ( ![[NSWorkspace sharedWorkspace] openFile:[[self url] path]] )
		{
			if ( ![[NSWorkspace sharedWorkspace] selectFile:[[self url] path] inFileViewerRootedAtPath:
					[[[self url] path] stringByDeletingLastPathComponent]] )
				NSBeep();
		}
	}
	else
		[super mouseDown:theEvent];
}

#pragma mark -

- (NSURL*) url
{
	return url;
}

- (void) setURL:(NSURL*)aURL
{
	if ( aURL != url )
	{
		[url release];
		url = [aURL copyWithZone:[self zone]];
		
		[[self window] invalidateCursorRectsForView:self];
	}
}


@end
