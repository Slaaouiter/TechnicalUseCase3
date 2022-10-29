@isTest
private class NotifyExternalSystemBatchJobTest {
  @isTest
  public static void notifiesExternalSystemIfContactIsEligibleAndEngagesSendingEmails() {
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
  public static void doesNotNotifyExternalSystemIfContactIsNotEligible() {
    //Given
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

    //When
    Test.startTest();
    NotifyExternalSystemBatchJob batch = new NotifyExternalSystemBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
    Test.stopTest();

    //Then
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
  public static void doesNotEngageSendingEmailIfExternalSystemIsDown() {
    //Given
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

    //When
    Test.startTest();
    NotifyExternalSystemBatchJob batch = new NotifyExternalSystemBatchJob();
    Id jobId = Database.executeBatch(batch, 100);
    Test.stopTest();

    //Then
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
