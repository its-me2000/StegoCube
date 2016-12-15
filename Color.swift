/*
* Structure for color representation
*
*
*/

import Foundation


struct Color:CustomStringConvertible {
    var r:Int
    var g:Int
    var b:Int
    var a:Int=0
    var description:String  {
        
        return HTMLString

    }
    var simpleText:String {
        return "red: \(r)\ngreen: \(g)\nblue: \(b)\nalpha: \(a)"
    }
    var HTMLString:String {
        let pref = "#"
        var hexStr = RGBAHex
        hexStr = hexStr.substring(to:
                                        hexStr.index(before:
                                        hexStr.index(before:
                                        hexStr.endIndex)))
        return pref + hexStr
    }
    var RGBAHex:String {
        var rstr = "0"+String(r, radix:16, uppercase:true)
        
            rstr = rstr.substring(from:
                                        rstr.index(before:
                                        rstr.index(before:
                                        rstr.endIndex)))

        var gstr = "0"+String(g, radix:16, uppercase:true)
        
            gstr = gstr.substring(from:
                                        gstr.index(before:
                                        gstr.index(before:
                                        gstr.endIndex)))
 
        var bstr = "0"+String(b, radix:16, uppercase:true)
        
            bstr = bstr.substring(from:
                                        bstr.index(before:
                                        bstr.index(before:
                                        bstr.endIndex)))
                                        
        var astr = "0"+String(a, radix:16, uppercase:true)
        
            astr = astr.substring(from:
                                        astr.index(before:
                                        astr.index(before:
                                        astr.endIndex)))
                                        
        return rstr+gstr+bstr+astr
    }
    
    init(r:Int,g:Int,b:Int,a:Int){
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    init(r:UInt8,g:UInt8,b:UInt8,a:UInt8){
        self.r = Int(r)
        self.g = Int(g)
        self.b = Int(b)
        self.a = Int(a)
    }
    func getUInt8RGBAValues()->(r:UInt8, g:UInt8, b:UInt8, a:UInt8){
        return (UInt8(r), UInt8(g), UInt8(b), UInt8(a))
    }
}
