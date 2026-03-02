# Skip analysis for blobs whose attachments have already been destroyed.
#
# When an upload is deleted before AnalyzeJob runs, PurgeOnLastAttachment has
# already destroyed the attachment row and enqueued PurgeJob for the blob's S3
# object. Analyzing at this point hits a missing key. Same check as
# PurgeOnLastAttachment#purge_blob_if_last.
module ActiveStorageAnalyzeJobSkipDetached
  def perform(blob)
    return unless blob.attachments.exists?

    super
  end
end

ActiveSupport.on_load :active_storage_blob do
  ActiveStorage::AnalyzeJob.prepend ActiveStorageAnalyzeJobSkipDetached
end
