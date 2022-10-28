@isTest
private class NotifyExternalSystemBatchJobTest {
  @isTest
  public static void notifies_external_system_if_contact_is_eligible_and_engage_into_sending_email() {
    Test.setMock(HttpCalloutMock.class, new ReservationCalloutMock(201));
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Contact salesforce1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 1 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact1@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );
    Contact salesforce2Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 2 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact2@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );
    Contact salesforce3Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 3 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact3@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );

    Test.startTest();
    NotifyExternalSystemBatchJob batch = new NotifyExternalSystemBatchJob();
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

  @isTest
  public static void does_not_notify_external_system_if_contact_is_not_eligible() {
    Test.setMock(HttpCalloutMock.class, new ReservationCalloutMock(201));
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Contact salesforce1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 1 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact1@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => false
      }
    );
    Test.startTest();
    NotifyExternalSystemBatchJob batch = new NotifyExternalSystemBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
    Test.stopTest();

    System.assertEquals(
      0,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          AccountId = :salesforce.Id
          AND NotifyExternalSystem__c = FALSE
          AND SendEmail__c = TRUE
      ]
    );
  }

  @isTest
  public static void does_not_engage_sending_email_if_external_system_is_down() {
    Test.setMock(HttpCalloutMock.class, new ReservationCalloutMock(500));
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Contact salesforce1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 1 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact1@gmail.com',
        'NotifyExternalSystem__c' => true,
        'SendEmail__c' => false
      }
    );
    Test.startTest();
    NotifyExternalSystemBatchJob batch = new NotifyExternalSystemBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
    Test.stopTest();

    System.assertEquals(
      0,
      [
        SELECT COUNT()
        FROM Contact
        WHERE
          AccountId = :salesforce.Id
          AND NotifyExternalSystem__c = FALSE
          AND SendEmail__c = TRUE
      ]
    );
  }
}
