using Google.Cloud.Storage.V1;
using Microsoft.AspNetCore.Http;
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace dotnet_gcs
{
    public class FileUploader
    {
        private readonly string _bucketName;
        private readonly StorageClient _storageClient;

        public FileUploader(string bucketName)
        {
            _bucketName = bucketName;
            _storageClient = StorageClient.Create();
        }

        public async Task<String> WriteFile(string content, string id)
        {
            var acl = PredefinedObjectAcl.PublicRead;
            var stream = new MemoryStream(Encoding.UTF8.GetBytes(content ?? ""));

            var storageObject = await _storageClient.UploadObjectAsync(
                bucket: _bucketName,
                objectName: id.ToString(),
                contentType: "text/plain",

                source: stream,
                options: new UploadObjectOptions { PredefinedAcl = acl }
            );

            return storageObject.SelfLink;
        }
    }
}
