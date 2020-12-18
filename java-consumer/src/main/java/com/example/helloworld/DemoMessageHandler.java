package com.example.helloworld;

import com.google.pubsub.v1.ProjectSubscriptionName;
import com.google.pubsub.v1.PubsubMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gcp.pubsub.support.BasicAcknowledgeablePubsubMessage;
import org.springframework.cloud.gcp.pubsub.support.GcpPubSubHeaders;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageHandler;
import org.springframework.messaging.MessagingException;

public class DemoMessageHandler implements MessageHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(DemoMessageHandler.class);

    @Override
    public void handleMessage(Message<?> message) throws MessagingException {
        String payload = new String((byte[]) message.getPayload());
        BasicAcknowledgeablePubsubMessage originalMessage = message.getHeaders()
                .get(GcpPubSubHeaders.ORIGINAL_MESSAGE, BasicAcknowledgeablePubsubMessage.class);
        if (originalMessage != null) {
            ProjectSubscriptionName name = originalMessage.getProjectSubscriptionName();
            PubsubMessage pubsubMessage = originalMessage.getPubsubMessage();
            LOGGER.warn(name + " sent " + pubsubMessage.getMessageId() + ": " + payload);
            Util.sleep();
            originalMessage.ack();
        }
    }
}
