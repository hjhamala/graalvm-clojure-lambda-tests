def handler(event, context):
    print ('{"headers": {"content-type": "text/html"},"isBase64Encoded": false, "body": "Hello Python World", "statusCode": 200}')
    return {"headers": {"content-type": "text/html"},"isBase64Encoded": False, "body": "Hello Python World", "statusCode": 200}