import AWSS3
import AWSCore

final class AWSS3Service {

    // TransferUtility supports background transfer
    private let transferutility = AWSS3TransferUtility.default()


    private var uploadCompletionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    private var progressBlock: AWSS3TransferUtilityProgressBlock?

    private var downloadCompletionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?

    static func setup() {
        // アプリ内で認証情報を持っているため初期化時に設定
        let credientialProvider = AWSStaticCredentialsProvider(accessKey: S3Credentials.accessKey, secretKey: S3Credentials.secretKey)
        let serviceConfigration = AWSServiceConfiguration(region: S3Credentials.region, credentialsProvider: credientialProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = serviceConfigration
    }
}

extension AWSS3Service {
    // TODO: - impl next ticket
    func uploadImage(imageUrl: URL,
                     uploadKeyName: String,
                     contentType: String,
                     inProgress: @escaping (_ task: AWSS3TransferUtilityTask, _ progress: Progress) -> Void,
                     success: @escaping () -> Void,
                     failure: @escaping (_ error: Error) -> Void) {

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            inProgress(task, progress)
        }

        // upload completed
        uploadCompletionHandler = { (task, error) -> Void in

            if let error = error {
                print(error)
            } else {
                success()
            }

        }

        transferutility.uploadFile(
            imageUrl,
            key: uploadKeyName,
            contentType: contentType,
            expression: expression,
            completionHandler: uploadCompletionHandler
        )
    }

    func downloadImage(downloadKeyName: String,
                       inProgress: @escaping (_ task: AWSS3TransferUtilityTask, _ progress: Progress) -> Void,
                       success: @escaping (_ data: Data) -> Void,
                       failure: @escaping (_ error: Error) -> Void) {

        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            inProgress(task, progress)
        }

        downloadCompletionHandler = { (task, location, data, error) -> Void in
            if let error = error {
                NSLog("Failed with error: \(error)")
                failure(error)
            }

            if let data = data {
                success(data)
            }
        }

        transferutility.downloadData(
            forKey: downloadKeyName,
            expression: expression,
            completionHandler: downloadCompletionHandler
        )
    }
}
