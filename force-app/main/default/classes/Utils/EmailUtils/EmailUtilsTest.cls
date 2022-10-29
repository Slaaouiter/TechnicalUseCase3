@isTest
private class EmailUtilsTest {
  @isTest
  public static void sendEmailsSingleMode() {
    //Given
    Contact contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact',
        'Email' => 'contact.salesforce@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );

    //When
    Test.startTest();
    EmailUtils.sendEmails(new List<Contact>{ contact });
    Integer invocations = Limits.getEmailInvocations();
    Test.stopTest();

    //Then
    System.assert(invocations == 1);
    System.assert(!contact.SendEmail__c);
  }

  @isTest
  public static void sendsEmailBulkMode() {
    //Given
    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact1',
        'Email' => 'contact1.salesforce@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );
    Contact contact2 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact',
        'Email' => 'contact2.salesforce@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );
    Contact contact3 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact',
        'Email' => 'contact3.salesforce@gmail.com',
        'NotifyExternalSystem__c' => false,
        'SendEmail__c' => true
      }
    );

    //When
    Test.startTest();
    EmailUtils.sendEmails(new List<Contact>{ contact1, contact2, contact3 });
    Integer invocations = Limits.getEmailInvocations();
    Test.stopTest();

    //Then
    System.assert(invocations == 1);
    System.assert(!contact1.SendEmail__c);
    System.assert(!contact2.SendEmail__c);
    System.assert(!contact3.SendEmail__c);
  }
}
