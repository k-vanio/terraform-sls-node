'use strict';

const jwt = require('jsonwebtoken');

module.exports.authorizer = async (event, context, callback) => {
    const token = event.authorizationToken;

    try {
        const user = jwt.verify(token, process.env.JWT_SECRET);
        callback(null, generatePolicy("user", 'Allow', event.methodArn, user));
    } catch (e) {
        console.log(e);
        callback(null, generatePolicy("user", 'Deny', event.methodArn));
    }    
};

const generatePolicy = (principalId, effect, resource, user) => {
    const authResponse = {
        principalId: principalId
    };

    if (effect && resource) {
        const policyDocument = {
            Version: '2012-10-17',
            Statement: [
                {
                    Action: 'execute-api:Invoke',
                    Effect: effect,
                    Resource: resource
                }
            ]
        };

        authResponse.policyDocument = policyDocument;
    }

    if (user) {
        authResponse.context = {
            auth: JSON.stringify(user)
        };
    }

    return authResponse;
}