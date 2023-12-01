'use strict';

const AWS = require('aws-sdk');
AWS.config.update({ 
  region: process.env.AWS_REGION 
});
const documentClient = new AWS.DynamoDB.DocumentClient();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

module.exports.login = async (event) => {
  const body = JSON.parse(event.body);
  const params = {
    TableName: process.env.DYNAMODB_USERS,
    IndexName: process.env.EMAIL_GSI,
    KeyConditionExpression: 'email = :email',
    ExpressionAttributeValues: { ':email': body.email }
  };

  const data = await documentClient.query(params).promise();

  if (data.Items.length === 0) {
    return {
      statusCode: 401,
      body: JSON.stringify({
        message: 'User not found!'
      })
    };
  }

  const user = data.Items[0];
  if (!bcrypt.compareSync(body.password, user.password)) {
    return {
      statusCode: 401,
      body: JSON.stringify({
        message: 'Incorrect password!'
      })
    };
  }

  delete user.password;
  const token = jwt.sign({ ...user }, process.env.JWT_SECRET, { expiresIn: '1d' });

  return {
    statusCode: 200,
    body: JSON.stringify({ token })
  };
};
