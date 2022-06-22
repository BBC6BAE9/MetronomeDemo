//
//  Metronome.h
//  Metronome
//
//  Created by huang on 2022/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Metronome : NSObject
/// 初始化节拍器
/// @param mainClickFile 音频文件URL
/// @param accentedClickFile 音频文件URL
- (instancetype)initWith:(NSURL *)mainClickFile
       accentedClickFile:(NSURL *)accentedClickFile;

- (void)play:(double)bpm;

@end

NS_ASSUME_NONNULL_END
