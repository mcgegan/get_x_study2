// To set up DynamoDB on AWS:
//
// 1. Create an AWS Account
//    - Go to aws.amazon.com and create a new account if you don't have one
//    - Sign in to the AWS Management Console
//
// 2. Create IAM User & Get Credentials
//    - Go to IAM service in AWS Console
//    - Create a new IAM user with programmatic access
//    - Attach 'AmazonDynamoDBFullAccess' policy
//    - Save the Access Key ID and Secret Access Key
//
// 3. Create DynamoDB Table
//    - Go to DynamoDB service in AWS Console
//    - Click 'Create table'
//    - Set table name (e.g. 'YourTableName')
//    - Set partition key to 'id' (String)
//    - Use default settings for other options
//    - Click 'Create'
//
// 4. Update Credentials
//    - Replace 'YOUR_ACCESS_KEY' with your Access Key ID
//    - Replace 'YOUR_SECRET_KEY' with your Secret Access Key
//    - Set region to your preferred AWS region
//
// 5. Security Best Practices
//    - Never commit credentials to source control
//    - Use environment variables or secure storage
//    - Follow principle of least privilege for IAM roles
//    - Enable encryption at rest (default in DynamoDB)
//    - Consider using AWS Secrets Manager for production

// DynamoDB Service for managing items in DynamoDB table
//
// Provides methods to:
// - Fetch all items from the table
// - Create new items with title and description
// - Update existing items by ID
// - Delete items by ID
//
// Configure with your AWS credentials and table name:
// - Set region to your AWS region (e.g. 'ap-northeast-2')
// - Replace 'YOUR_ACCESS_KEY' with your AWS access key
// - Replace 'YOUR_SECRET_KEY' with your AWS secret key
// - Replace 'YourTableName' with your DynamoDB table name
//
// Table schema:
// - id (String): Primary key, auto-generated timestamp
// - title (String): Item title
// - description (String): Item description

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import '../config/aws_config.dart';

class DynamoDBService {
  final DynamoDB dynamoDB = DynamoDB(
    region: AWSConfig.region,
    credentials: AwsClientCredentials(
      accessKey: AWSConfig.accessKey,
      secretKey: AWSConfig.secretKey,
    ),
  );

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await dynamoDB.scan(tableName: AWSConfig.tableName);
    return response.items ?? [];
  }

  Future<void> createItem(String title, String description) async {
    await dynamoDB.putItem(
      tableName: AWSConfig.tableName,
      item: {
        'id': AttributeValue(
          s: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
        'title': AttributeValue(s: title),
        'description': AttributeValue(s: description),
      },
    );
  }

  Future<void> updateItem(String id, String title, String description) async {
    await dynamoDB.updateItem(
      tableName: AWSConfig.tableName,
      key: {'id': AttributeValue(s: id)},
      attributeUpdates: {
        'title': AttributeValueUpdate(
          value: AttributeValue(s: title),
          action: AttributeAction.put,
        ),
        'description': AttributeValueUpdate(
          value: AttributeValue(s: description),
          action: AttributeAction.put,
        ),
      },
    );
  }

  Future<void> deleteItem(String id) async {
    await dynamoDB.deleteItem(
      tableName: AWSConfig.tableName,
      key: {'id': AttributeValue(s: id)},
    );
  }

  String getItemTitle(Map<String, dynamic>? item) {
    if (item == null) return '';
    final titleAttr = item['title'] as AttributeValue?;
    return titleAttr?.s ?? '';
  }

  String getItemDescription(Map<String, dynamic>? item) {
    if (item == null) return '';
    final descriptionAttr = item['description'] as AttributeValue?;
    return descriptionAttr?.s ?? '';
  }
}
