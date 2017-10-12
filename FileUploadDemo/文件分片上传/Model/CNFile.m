//
//  CNFile.m
//  文件分片上传
//
//  Created by seehoo on 2017/9/18.
//  Copyright © 2017年 seehoo. All rights reserved.
//

#import "CNFile.h"

@implementation CNFile

-(void)readDataWithChunk:(NSInteger)chunk file:(CNFile*)file{
    
    //总片数的获取方法：
    
    int offset = 1024*1024;//（每一片的大小是1M）
    
    NSInteger chunks = (file.fileSize%1024==0)?((int)(file.fileSize/1024*1024)):((int)(file.fileSize/(1024*1024) + 1));
    
    NSLog(@"chunks = %ld",(long)chunks);
    
   // 将文件分片，读取每一片的数据：
    
    NSData* data;
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:file.filePath];
    
    [readHandle seekToFileOffset:offset * chunk];
    
    data = [readHandle readDataOfLength:offset];

}


@end
