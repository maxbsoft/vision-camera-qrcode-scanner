import MLKitBarcodeScanning
import MLKitVision

@objc(VisionCameraQrcodeScanner)
class VisionCameraQrcodeScanner: NSObject, FrameProcessorPluginBase {
    
    static var format: BarcodeFormat = .EAN13
    static var barcodeOptions = BarcodeScannerOptions(formats: format)
    static var barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
    
    @objc
     public static func callback(_ frame: Frame!, withArgs _: [Any]!) -> Any! {
       
       let image = VisionImage(buffer: frame.buffer)
       image.orientation = .up
       var barCodeAttributes: [Any] = []
        
       do {
           let barcodes: [Barcode] =  try barcodeScanner.results(in: image)
           if (!barcodes.isEmpty){
                for barcode in barcodes {
                    var map: [String: Any] = [:]
                    map["displayValue"] = barcode.displayValue
                    map["rawValue"] = barcode.rawValue
                    map["frameMinX"] = barcode.frame.minX
                    map["frameMinY"] = barcode.frame.minY
                    map["frameWidth"] = barcode.frame.width
                    map["frameHeight"] = barcode.frame.height
                    map["barcodeType"] = "EAN13"
                    barCodeAttributes.append(map)
                }
           }
         } catch _ {
               return nil
         }
       
       return barCodeAttributes
        
    }
}
