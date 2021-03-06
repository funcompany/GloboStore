//
// Created by BENJAMIN LISBAKKEN on 10/12/17.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface GStore : NSObject
+ (void)setObject:(id)object atKeyPath:(NSString *)keyPath;
+ (id)getObjectAtKeyPath:(NSString *)keyPath;
+ (RACSignal *)listenAtKeyPath:(NSString *)keyPath;
@end

