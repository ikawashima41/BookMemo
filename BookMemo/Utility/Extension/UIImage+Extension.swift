import Foundation
import UIKit

extension UIImage  {
    static func convertImageToString(image: UIImage) -> String {
        guard let imageData = image.pngData() else { return "No Image" }
        let imageDataTypeString = imageData.base64EncodedString()
        return imageDataTypeString
    }
}
