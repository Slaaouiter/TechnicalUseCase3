@isTest
private class CaseTriggerHelperTest {
  @isTest
  public static void validateCasesRefusesCaseCreationWhenItIsNotRelatedToAnAccount() {
    // Given
    Case request = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots'
    );

    // When
    Test.startTest();
    Database.SaveResult result = Database.insert(request, false);
    Test.stopTest();

    // Then
    System.assert(!result.isSuccess());
    System.assert(result.getErrors().size() > 0);
    System.assertEquals(
      Label.YouCannotCreateARequestWithoutAttachingAnAccount,
      result.getErrors()[0].getMessage()
    );
  }

  @isTest
  public static void validateCasesRefusesCaseCreationWhenTheRelatedAccountHasNoContacts() {
    // Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Case request = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots',
      AccountId = salesforce.Id
    );

    // When
    Test.startTest();
    Database.SaveResult result = Database.insert(request, false);
    Test.stopTest();

    // Then
    System.assert(!result.isSuccess());
    System.assert(result.getErrors().size() > 0);
    System.assertEquals(
      Label.YouCanNotCreateARequestForAccountWithoutAccount,
      result.getErrors()[0].getMessage()
    );
  }

  @isTest
  public static void validateCasesAcceptsCaseCreationWithPhoneOriginAndRelatedToAnAccountWithLessThan4Contacts() {
    // Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id
      }
    );
    Contact contact2 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 2',
        'AccountId' => salesforce.Id
      }
    );
    Contact contact3 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 3',
        'AccountId' => salesforce.Id
      }
    );

    Case reservation = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their 3 employees',
      AccountId = salesforce.Id
    );

    // When
    Test.startTest();
    Database.SaveResult result = Database.insert(reservation, false);
    Test.stopTest();

    // Thenxz
    System.assert(result.isSuccess());
  }

  @isTest
  public static void validateCasesRefusesCaseCreationWithPhoneOriginAndRelatedToAnAccountWithMoreThan3Contacts() {
    // Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id
      }
    );
    Contact contact2 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 2',
        'AccountId' => salesforce.Id
      }
    );
    Contact contact3 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 3',
        'AccountId' => salesforce.Id
      }
    );
    Contact contact4 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 4',
        'AccountId' => salesforce.Id
      }
    );

    Case request = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their 4 employees',
      AccountId = salesforce.Id
    );

    // When
    Test.startTest();
    Database.SaveResult result = Database.insert(request, false);
    Test.stopTest();

    // Then
    System.assert(!result.isSuccess());
    System.assert(result.getErrors().size() > 0);
    System.assertEquals(
      Label.PhoneRequestAreOnlyAllowedToHaveThreeAttendee,
      result.getErrors()[0].getMessage()
    );
  }

  @isTest
  public static void validateCasesAcceptsCaseCreationWithWebOriginAndRelatedToAnAccountWithOneContact() {
    // Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id
      }
    );

    Case request = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book One Spot for Salesforce Company & 1 employee',
      AccountId = salesforce.Id
    );

    // When
    Test.startTest();
    Database.SaveResult result = Database.insert(request, false);
    Test.stopTest();

    // Then
    System.assert(result.isSuccess());
  }

  @isTest
  public static void validateCasesRefusesCaseCreationWithWebOriginAndRelatedToAnAccountWithMoreThanOneContact() {
    // Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id
      }
    );
    Contact contact2 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 2',
        'AccountId' => salesforce.Id
      }
    );

    Case request = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their 2 employees',
      AccountId = salesforce.Id
    );

    // When
    Test.startTest();
    Database.SaveResult result = Database.insert(request, false);
    Test.stopTest();

    // Then
    System.assert(!result.isSuccess());
    System.assert(result.getErrors().size() > 0);
    System.assertEquals(
      Label.WebRequestAreOnlyAllowedToHaveOneAttendee,
      result.getErrors()[0].getMessage()
    );
  }

  @isTest
  public static void validateCasesTestBulkMode() {
    //Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Account altice = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Altice' }
    );

    Contact salesforce1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce Contact 1',
        'AccountId' => salesforce.Id
      }
    );
    Contact salesforce2Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce Contact 2',
        'AccountId' => salesforce.Id
      }
    );
    Contact salesforce3Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce Contact 3',
        'AccountId' => salesforce.Id
      }
    );
    Contact altice1contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Altice Contact 1',
        'AccountId' => altice.Id
      }
    );

    Case salesforce1Request = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their 3 employees',
      AccountId = salesforce.Id
    );
    Case salesforce2Request = new Case(
      Origin = 'Phone',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their 3 employees',
      AccountId = salesforce.Id
    );
    Case altice1Request = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book Spots for Altice Company & their employee',
      AccountId = altice.Id
    );

    List<Case> requests = new List<Case>{
      salesforce1Request,
      salesforce2Request,
      altice1Request
    };

    //When
    Test.startTest();
    List<Database.SaveResult> results = Database.insert(requests, false);
    Test.stopTest();

    //Then
    List<Case> salesforceRequests = [
      SELECT Id, Origin, Subject
      FROM Case
      WHERE AccountId = :salesforce.Id
    ];
    System.assert(salesforceRequests.size() == 1);

    Case salesforceRequest = salesforceRequests.get(0);
    System.assert('Phone'.equals(salesforceRequest.Origin));
    System.assert('Event Booking'.equals(salesforceRequest.Subject));

    List<Case> alticeRequests = [
      SELECT Id, Origin, Subject
      FROM Case
      WHERE AccountId = :altice.Id
    ];
    System.assert(alticeRequests.size() == 1);

    Case alticeRequest = alticeRequests.get(0);
    System.assert('Web'.equals(alticeRequest.Origin));
    System.assert('Event Booking'.equals(alticeRequest.Subject));
  }

  @isTest
  public static void updateRelatedContactsUpdatesRelatedContactsWithNotifyExternalSystemToTrueIfTheCaseIsClosed() {
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Account altice = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Altice' }
    );

    Contact salesforce1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 1 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact1@gmail.com'
      }
    );
    Contact salesforce2Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 2 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact2@gmail.com'
      }
    );
    Contact altice1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Altice 1 Contact',
        'AccountId' => altice.Id,
        'Email' => 'altice.contact1@gmail.com'
      }
    );

    Case salesforce1Request = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{
        'Origin' => 'Phone',
        'Subject' => 'Event Booking',
        'Description' => 'Book Spots for salesforce  & their contacts',
        'AccountId' => salesforce.Id
      }
    );
    Case altice1Request = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{
        'Origin' => 'Web',
        'Subject' => 'Event Booking',
        'Description' => 'Book Spots for altice contact',
        'AccountId' => altice.Id
      }
    );
    Case altice2Request = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{
        'Origin' => 'Phone',
        'Subject' => 'Event Booking',
        'Description' => 'Book Spots for altice contact',
        'AccountId' => altice.Id
      }
    );

    //When
    Test.startTest();

    altice1Request.Status = 'Closed';
    altice2Request.Status = 'Closed';
    salesforce1Request.Status = 'Closed';

    List<Case> requestsToUpdate = new List<Case>{
      altice1Request,
      altice2Request,
      salesforce1Request
    };

    update requestsToUpdate;

    Test.stopTest();

    //Then
    List<Id> accountIds = new List<Id>{ salesforce.Id, altice.Id };
    List<Contact> contacts = [
      SELECT NotifyExternalSystem__c
      FROM Contact
      WHERE AccountId IN :accountIds
    ];
    for (Contact contact : contacts) {
      System.assert(contact.NotifyExternalSystem__c);
    }
  }

  @isTest
  public static void updateRelatedContactsDoesNotUpdatesRelatedContactsWithNotifyExternalSystemToTrueIfTheCaseIsNotClosed() {
    //Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );
    Contact salesforce1Contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Salesforce 1 Contact',
        'AccountId' => salesforce.Id,
        'Email' => 'salesforce.contact1@gmail.com'
      }
    );
    Case salesforce1Request = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{
        'Origin' => 'Web',
        'Subject' => 'Event Booking',
        'Description' => 'Book Spots for salesforce contact',
        'AccountId' => salesforce.Id
      }
    );

    //When
    Test.startTest();
    salesforce1Request.Status = 'Escalated';
    update salesforce1Request;
    Test.stopTest();

    //Then
    Contact contact = [
      SELECT NotifyExternalSystem__c
      FROM Contact
      WHERE AccountId = :salesforce.Id
      LIMIT 1
    ];
    System.assert(!contact.NotifyExternalSystem__c);
    System.assert(salesforce1Contact.Id.equals(contact.Id));
  }
}
