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
                   switch barcode.valueType {
                   case .URL:
                       map["title"] = barcode.url?.title
                       map["url"] = barcode.url?.url
                   case .wiFi:
                       map["password"] = barcode.wifi?.password
                       map["encryptionType"] = barcode.wifi?.type
                       map["ssid"] = barcode.wifi?.ssid
                   default:
                    
                        map["displayValue"] = barcode.displayValue
                        // map["valueType"] = barcode.valueType
                        map["rawValue"] = barcode.rawValue
                        // map["rawData"] = String(decoding: barcode.rawData, as: UTF8.self)
                        

                        if (barcode.format == .code128) {
                            map["barcodeType"] = "code128"
                        } else if (barcode.format == .code128) {
                            map["barcodeType"] = "code39"
                        } else if (barcode.format == .code93) {
                            map["barcodeType"] = "code93"
                        } else if (barcode.format == .codeBar) {
                            map["barcodeType"] = "codeBar"
                        } else if (barcode.format == .EAN13) {
                            map["barcodeType"] = "EAN13"
                        } else if (barcode.format == .EAN8) {
                            map["barcodeType"] = "EAN8"
                        }
                        
                   }
                   barCodeAttributes.append(map)
                 }
           }
         } catch _ {
               return nil
         }
       
       return barCodeAttributes
        
    }
}
