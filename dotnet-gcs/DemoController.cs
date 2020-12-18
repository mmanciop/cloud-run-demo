using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace dotnet_gcs
{
    [Route("")]
    public class DemoController : ControllerBase
    {

        private readonly ILogger<DemoController> _logger;
        private FileUploader _fileUploader;

        public DemoController(ILogger<DemoController> logger, FileUploader fileUploader)
        {
            _logger = logger;
            _fileUploader = fileUploader;
        }

        [HttpGet]
        public async System.Threading.Tasks.Task<string> IndexAsync()
        {
            return  await _fileUploader.WriteFile("Hello World", System.Guid.NewGuid().ToString());
        }
    }
}
