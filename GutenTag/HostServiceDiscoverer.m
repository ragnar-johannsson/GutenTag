//
//  HostServiceDiscoverer.m
//  GutenTag
//
//  Created by Ragnar B. Jóhannsson on 10/15/13.
//  Copyright (c) 2013 Ragnar B. Jóhannsson. All rights reserved.
//

#import "HostServiceDiscoverer.h"

@implementation HostServiceDiscoverer

- (id)init {
    self = [super init];
    
    if (self) {
        serviceBrowserDict = [[NSMutableDictionary alloc] init];
        servicesDict = [[NSMutableDictionary alloc] init];
        hostsDict = [[NSMutableDictionary alloc] init];
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    }
    
    return self;
}

- (void)addService:(NSNetService *)netService {
    NSString *serviceName = [NSString stringWithFormat:@"%@.%@",
        netService.name,
        [netService.type substringWithRange:NSMakeRange(0, 4)]
    ];
    
    if ([serviceBrowserDict objectForKey:serviceName]) {
        return;
    }
    
    NSNetServiceBrowser *browser = [[NSNetServiceBrowser alloc] init];
    [browser setDelegate:self];
    [browser searchForServicesOfType:serviceName inDomain:@""];
    [serviceBrowserDict setValue:browser forKey:serviceName];
}

- (void)hostOnline:(NSString *)host {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Online";
    notification.informativeText = host;
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)hostOffline:(NSString *)host {    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Offline";
    notification.informativeText = host;
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

# pragma mark NetServiceBrowserDelegate methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
           didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSMutableDictionary *service = [servicesDict objectForKey:aNetService.name];
    if (!service) {
        service = [[NSMutableDictionary alloc] init];
        [servicesDict setValue:service forKey:aNetService.name];
    }
    
    [service setValue:aNetService forKey:aNetService.type];
    
    [aNetService setDelegate:self];
    [aNetService resolveWithTimeout:5.0];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
         didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSMutableDictionary *service = [servicesDict objectForKey:aNetService.name];
    if (!service)return;
    
    NSNetService *stored = [service objectForKey:aNetService.type];
    NSMutableDictionary *hostServices = [hostsDict objectForKey:stored.hostName];
    if (hostServices) {
        [hostServices removeObjectForKey:stored.type];

        if (hostServices.count == 0) {
            [hostsDict removeObjectForKey:stored.hostName];
            [self hostOffline:stored.hostName];
        }
    }
    
    [service removeObjectForKey:aNetService.type];
    
    if (service.count == 0) {
        [servicesDict removeObjectForKey:aNetService.name];
    }
}

# pragma mark NSNetServiceDelgate methods

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    if (!sender.hostName || [sender.hostName isEqual:@""] || [sender.hostName rangeOfString:@":"].location != NSNotFound) {
        return;
    }
    
    NSMutableDictionary *hostServices = [hostsDict objectForKey:sender.hostName];
    if (!hostServices) {
        hostServices = [[NSMutableDictionary alloc] init];
        [hostsDict setValue:hostServices forKey:sender.hostName];
        [self hostOnline:sender.hostName];
    }

    [hostServices setValue:sender forKey:sender.type];
}

# pragma mark NSUserNotificationCenterDelegate methods

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
        shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}


@end
