//
//  AppDelegate.m
//  GutenTag
//
//  Created by Ragnar B. Jóhannsson on 10/12/13.
//  Copyright (c) 2013 Ragnar B. Jóhannsson. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"GT"];
    [statusItem setHighlightMode:true];
    
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    [serviceBrowser searchForServicesOfType:@"_services._dns-sd._udp" inDomain:@""];
    
    discoverer = [[HostServiceDiscoverer alloc] init];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
        didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    [discoverer addService:aNetService];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
        didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {    
}

@end
