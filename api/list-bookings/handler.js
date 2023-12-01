'use strict';

const AWS = require('aws-sdk');
AWS.config.update({ region: process.env.REGION });

const documentClient = new AWS.DynamoDB.DocumentClient();

module.exports.list = async (event) => {
  const user = JSON.parse(event.requestContext.authorizer.auth)

  if (user.role !== 'admin') {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: 'Forbidden' })
    };
  }

  const params = {
    TableName: process.env.DYNAMODB_BOOKINGS,
    Limit: 100
  };

  try {
    const data = await documentClient.scan(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify(data.Items)
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: err.message })
    };
  }

};
