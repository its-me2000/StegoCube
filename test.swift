var bufptr=UnsafeMutableRawBufferPointer.allocate(count:64)

let btmpInf=BitmapInfo(width:4, height:4)

var ids=ImageDataSource(data:bufptr, bitmapInfo:btmpInf)

print(ids)

let cCube:ColorCube = ColorCube(with:ids)
print(cCube)

cCube.getColorNodes().forEach({e in print(e)})

cCube.getColorNodes().forEach(){e in
                                    e.addStego(0)
                                }
