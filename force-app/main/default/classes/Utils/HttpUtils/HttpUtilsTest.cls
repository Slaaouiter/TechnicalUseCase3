@isTest
private class HttpUtilsTest {
  @isTest
  public static void notifyExternalSystemCallsExternalSystemAndUpdatesContacts() {
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

    //When
    Test.startTest();
    HttpUtils.notifyExternalSystem(
      new List<Contact>{ salesforce1Contact, salesforce2Contact }
    );
    Test.stopTest();

    //Then
    System.assert(!salesforce1Contact.NotifyExternalSystem__c);
    System.assert(salesforce1Contact.SendEmail__c);

    System.assert(!salesforce2Contact.NotifyExternalSystem__c);
    System.assert(salesforce2Contact.SendEmail__c);
  }

  @isTest
  public static void notifyExternalSystemFailsCallingExternalSystemAndDoesNotUpdateContacts() {
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
    HttpUtils.notifyExternalSystem(new List<Contact>{ salesforce1Contact });
    Test.stopTest();

    //Then
    System.assert(salesforce1Contact.NotifyExternalSystem__c);
    System.assert(!salesforce1Contact.SendEmail__c);

    List<Log__c> logs = [SELECT Message__c, Method__c FROM Log__c];
    System.assert(logs.size() == 1);

    Log__c log = logs.get(0);
    System.assertEquals(log.Method__c, 'registerContact');
    System.assert(
      log.Message__c.contains('The status code returned was not expected: 500')
    );
  }
}
