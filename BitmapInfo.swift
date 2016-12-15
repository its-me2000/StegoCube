/*
* Stub for BitmapInfo data
*
*
*/
class BitmapInfo{
    enum ColorMode {
        case RGBA
        case ARGB
    }
    let bpc:Int = 8888
    let colorMode:ColorMode = .RGBA
    let width:Int
    let height:Int
    
    init(width:Int, height:Int){
        self.width  = width
        self.height = height
    }
    
}
