using System;
using Google.Cloud.PubSub.V1;
using Google.Protobuf;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace dotnet_gcs
{
    [Route("/pubsub")]
    public class PubSubController : ControllerBase
    {

        private readonly ILogger<PubSubController> _logger;
        private PublisherServiceApiClient _pubSubClient;

        public PubSubController(ILogger<PubSubController> logger)
        {
            _logger = logger;
            _pubSubClient = PublisherServiceApiClient.Create();
        }

        [HttpGet]
        public string Index()
        {
            var project = Environment.GetEnvironmentVariable("GCP_PROJECT") ?? "demo";
            var topicName = Environment.GetEnvironmentVariable("PUBSUB_TOPIC") ?? "demo";

            try
            {
                PubsubMessage message = new PubsubMessage
                {
                    // The data is any arbitrary ByteString. Here, we're using text.
                    Data = ByteString.CopyFromUtf8("message "),
                    // The attributes provide metadata in a string-to-string dictionary.RpcException: Status(StatusCode=Internal, Detail="A service error has occurred. Please retry your request. If the error persists, please report it. [code=e8c0]")

                Attributes =
                {
                    { "description", "Simple text message " }
                }
                };
                var res = _pubSubClient.Publish(TopicName.FromProjectTopic(project, topicName), new[] { message });

                return res.MessageIds.ToString();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);

                return e.Message;
            }
        }
    }
}
