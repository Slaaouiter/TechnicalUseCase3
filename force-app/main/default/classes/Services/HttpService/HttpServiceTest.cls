@isTest
private class HttpServiceTest {
  @isTest
  public static void notifyExternalSystem_succed_calling_external_system_and_updates_contacts() {
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
    HttpService.notifyExternalSystem(
      new List<Contact>{ salesforce1Contact, salesforce2Contact }
    );
    Test.stopTest();
    //Then
    System.assert(salesforce1Contact.NotifyExternalSystem__c == false);
    System.assert(salesforce1Contact.SendEmail__c == true);

    System.assert(salesforce2Contact.NotifyExternalSystem__c == false);
    System.assert(salesforce2Contact.SendEmail__c == true);
  }

  @isTest
  public static void notifyExternalSystem_fails_calling_external_system_and_does_not_update_contacts() {
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
    HttpService.notifyExternalSystem(new List<Contact>{ salesforce1Contact });
    Test.stopTest();
    //Then
    System.assert(salesforce1Contact.NotifyExternalSystem__c == true);
    System.assert(salesforce1Contact.SendEmail__c == false);

    List<Log__c> logs = [SELECT Message__c, Method__c FROM Log__c];
    System.assert(logs.size() == 1);

    Log__c log = logs.get(0);
    System.assertEquals(log.Method__c, 'registerContact');
    System.assert(
      log.Message__c.contains('The status code returned was not expected: 500')
    );
  }
}
