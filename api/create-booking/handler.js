'use strict';

const AWS = require('aws-sdk');
AWS.config.update({ region: process.env.REGION });

const uuid = require('uuid');
const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.create = async (event) => {
  const body = JSON.parse(event.body);

  await documentClient.put({
    TableName: process.env.DYNAMODB_BOOKINGS,
    Item: {
      id: uuid.v1(),
      date: body.date,
      user: JSON.parse(event.requestContext.authorizer.auth),
    }
  }).promise();

  return {
    statusCode: 201,
    body: JSON.stringify({ message: 'Booking created successfully!' })
  };
};
