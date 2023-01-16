//
//  DebugUtils.swift
//  INSTO Tap
//
//  Created by Andrew Wang on 2020/9/22.
//  Copyright © 2020 INSTO. All rights reserved.
//

import Foundation

var dateFormatter: DateFormatter {
    let format = DateFormatter()
//    format.timeZone = .current
    format.timeZone = TimeZone(identifier: "Asia/Taipei")
    format.dateFormat = "yyyy/MM/dd HH:mm:ss SSS"
    return format
}

func debug(_ objects:Any..., separator: String = " ", terminator: String = "\n",file:String = #file,line:Int = #line, function:String = #function){
    #if DEBUG
    print((file).split(separator: "/").last!,line.description + ":",function)
    print("🙋🏼‍♂️Debug info:  \n\t", terminator: "")
    print("time: \(dateFormatter.string(from: Date()))")
    
    for i in objects{
        print(i, separator: "", terminator: separator)
    }
    print(terminator)
    #endif
}
