import AWSS3
import AWSCore
import RxSwift

final class AWSS3Service {

    // 別ファイルで一括管理
    private struct S3Credentials {
        static let accessKey: String = ""
        static let secretKey: String = ""
        static let sessionToken: String = ""
        static let bucket: String = ""
        static let region: AWSRegionType = AWSRegionType.APNortheast1
    }

    init() {
        // アプリ内で認証情報を持っているため初期化時に設定
        let credientialProvider = AWSStaticCredentialsProvider(accessKey: S3Credentials.accessKey, secretKey: S3Credentials.secretKey)
        let serviceConfigration = AWSServiceConfiguration(region: S3Credentials.region, credentialsProvider: credientialProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = serviceConfigration
    }
}

extension AWSS3Service {
    // TODO: - impl next ticket
    func uploadImage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {}

    func downloadImage(imageUrl: URL, complation: @escaping (Result<Data, Error>) -> Void) {}

    func cancelTask() {}
}
