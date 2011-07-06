//
//  SproutedAnchoredDocumentView.m
//  SproutedInterface
//
//  Created by Philip Dow on 8/26/08.
//  Copyright 2008 Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/SproutedAnchoredDocumentView.h>


@implementation SproutedAnchoredDocumentView

- (id)initWithFrame:(NSRect)frame {
	if ([super initWithFrame:frame]) {
		startHeight = NSHeight(frame);
	}
	return self;
}

- (void)setFrame:(NSRect)frame {
	frame.size.height = MAX([[[self enclosingScrollView] contentView] frame].size.height, startHeight);
	[super setFrame:frame];
}

@end
