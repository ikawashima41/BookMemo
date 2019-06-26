import AVFoundation
import RxSwift

public enum AVCaptureDeviceExError: Error {
    case notAuthorized
    case authorizationDenied
}

extension AVCaptureDevice {
    static func authorize() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let mediaType = AVMediaType.video
            switch AVCaptureDevice.authorizationStatus(for: mediaType) {
            case .authorized:
                observer.onNext(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { granted in
                    if granted {
                        observer.onNext(true)
                    } else {
                        observer.onError(AVCaptureDeviceExError.authorizationDenied)
                    }
                })
            default:
                observer.onError(AVCaptureDeviceExError.notAuthorized)
            }
            return Disposables.create()
        }
    }
}

