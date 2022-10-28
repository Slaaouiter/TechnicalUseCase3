@isTest
private class SendEmailBatchJobTest {
  @isTest
  public static void sends_emails_if_contacts_are_eligible() {
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id,
        'Email' => 'contact1@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );
    Contact contact2 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 2',
        'AccountId' => salesforce.Id,
        'Email' => 'contact2@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );
    Contact contact3 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 3',
        'AccountId' => salesforce.Id,
        'Email' => 'contact3@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );

    Test.startTest();
    SendEmailBatchJob batch = new SendEmailBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
    Test.stopTest();

    System.assertEquals(
      3,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          AccountId = :salesforce.Id
          AND NotifyExternalSystem__c = FALSE
          AND SendEmail__c = FALSE
      ]
    );
  }
  public static void does_not_send_emails_if_contacts_are_not_eligible() {
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id,
        'Email' => 'contact1@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );
    Contact contact2 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 2',
        'AccountId' => salesforce.Id,
        'Email' => 'contact2@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );
    Contact contact3 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 3',
        'AccountId' => salesforce.Id,
        'Email' => 'contact3@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );

    Test.startTest();
    SendEmailBatchJob batch = new SendEmailBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
    Test.stopTest();

    System.assertEquals(
      0,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          AccountId = :salesforce.Id
          AND NotifyExternalSystem__c = TRUE
          AND SendEmail__c = FALSE
      ]
    );
  }
}
