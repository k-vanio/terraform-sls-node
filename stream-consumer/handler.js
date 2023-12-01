'use strict';

const AWS = require('aws-sdk');
AWS.config.update({ region: process.env.REGION });

const SNS = new AWS.SNS();

const converter = AWS.DynamoDB.Converter;

module.exports.listener = async (event) => {
  const snsPromises = []

  for (const record of event.Records) {
    if (record.eventName === 'INSERT') {
      snsPromises.push(SNS.publish({
        TopicArn: process.env.SNS_NOTIFICATIONS_TOPIC,
        Message: JSON.stringify(converter.unmarshall(record.dynamodb.NewImage))
      }).promise())
    }
  }
  
  await Promise.all(snsPromises)

  return { 
    message: 'Go Serverless v1.0! Your function executed successfully!', 
    event 
  };
};
