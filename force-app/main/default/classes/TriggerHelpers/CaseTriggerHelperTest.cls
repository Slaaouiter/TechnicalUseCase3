@isTest
private class CaseTriggerHelperTest {
  @isTest
  public static void validateReservation_refuses_case_creation_when_it_is_not_related_to_an_account() {
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
    System.assert(!result.isSuccess(), 'Result of insert should be a failure');
    System.assert(
      result.getErrors().size() > 0,
      'result.getErrors() array should not be empty'
    );
    System.assertEquals(
      Label.YouCannotCreateARequestWithoutAttachingAnAccount,
      result.getErrors()[0].getMessage(),
      'The error message should be : You cannot create a request without attaching an account'
    );
  }

  @isTest
  public static void validateReservation_refuses_case_creation_when_the_related_account_has_no_contacts() {
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
    System.assert(!result.isSuccess(), 'Result of insert should be a failure');
    System.assert(
      result.getErrors().size() > 0,
      'result.getErrors() array should not be empty'
    );
    System.assertEquals(
      Label.YouCanNotCreateARequestForAccountWithoutAccount,
      result.getErrors()[0].getMessage(),
      'The error message should be : You cannot create a request for accounts without contacts'
    );
  }

  @isTest
  public static void validateReservation_accepts_case_creation_with_phone_origin_and_related_to_an_account_with_less_than_4_contacts() {
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

    // Then

    System.assert(
      result.isSuccess(),
      'The reservation should be created without issue'
    );
  }

  @isTest
  public static void validateReservation_refuses_case_creation_with_phone_origin_and_related_to_an_account_with_more_than_3_contacts() {
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
    System.assert(!result.isSuccess(), 'Result of insert should be a failure');
    System.assert(
      result.getErrors().size() > 0,
      'result.getErrors() array should not be empty'
    );
    System.assertEquals(
      Label.PhoneRequestAreOnlyAllowedToHaveThreeAttendee,
      result.getErrors()[0].getMessage(),
      'The error message should be : Phone request are only allowed to have three attendee'
    );
  }

  @isTest
  public static void validateReservation_accepts_case_creation_with_web_origin_and_related_to_an_account_with_one_contact() {
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

    System.assert(
      result.isSuccess(),
      'The reservation should be created without issue'
    );
  }

  @isTest
  public static void validateReservation_refuses_case_creation_with_web_origin_and_related_to_an_account_with_more_than_one_contact() {
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

    Case request = new Case(
      Origin = 'Web',
      Subject = 'Event Booking',
      Description = 'Book Spots for Salesforce Company & their 3 employees',
      AccountId = salesforce.Id
    );

    // When

    Test.startTest();

    Database.SaveResult result = Database.insert(request, false);

    Test.stopTest();

    // Then
    System.assert(!result.isSuccess(), 'Result of insert should be a failure');
    System.assert(
      result.getErrors().size() > 0,
      'result.getErrors() array should not be empty'
    );
    System.assertEquals(
      Label.WebRequestAreOnlyAllowedToHaveOneAttendee,
      result.getErrors()[0].getMessage(),
      'The error message should be : Web request are only allowed to have one attendee'
    );
  }

  @isTest
  public static void validateReservation_test_bulk_mode() {
    //Given
    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
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

    Account altice = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Altice' }
    );

    Contact altice1contact = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Altice Contact 1',
        'AccountId' => altice.Id
      }
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
    System.assert(
      salesforceRequests.size() == 1,
      'Only one reservation for salesforce was created'
    );
    Case salesforceRequest = salesforceRequests.get(0);
    System.assert('Phone'.equals(salesforceRequest.Origin));
    System.assert('Event Booking'.equals(salesforceRequest.Subject));

    List<Case> alticeRequests = [
      SELECT Id, Origin, Subject
      FROM Case
      WHERE AccountId = :altice.Id
    ];
    System.assert(
      alticeRequests.size() == 1,
      'Reservation for altice was created'
    );
    Case alticeRequest = alticeRequests.get(0);
    System.assert('Web'.equals(alticeRequest.Origin));
    System.assert('Event Booking'.equals(alticeRequest.Subject));
  }
  @isTest
  public static void registerAttendeesLogsErrorWhenExternalSystemIsntWorkingAccordingly() {
    //Given
    Test.setMock(HttpCalloutMock.class, new ReservationCalloutMock(500));

    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id,
        'Email' => 'contact1@test.com'
      }
    );

    Case request = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{
        'Origin' => 'Web',
        'Subject' => 'Event Booking',
        'Description' => 'Book Spots for Company A1 & their 3 employees',
        'AccountId' => salesforce.Id
      }
    );
    //When
    Test.startTest();
    request.Status = 'Closed';
    update request;
    Test.stopTest();
    //Then
    List<Log__c> logs = [SELECT Message__c, Method__c FROM Log__c];
    System.assert(logs.size() == 1, 'One log exists');
    Log__c log = logs.get(0);
    System.assertEquals(
      log.Method__c,
      'registerAttendee',
      'the method is registerAttendee'
    );
    System.assert(
      log.Message__c.contains('The status code returned was not expected: 500'),
      'the message doesn\'t contains The status code returned was not expected: 500'
    );
  }
  @isTest
  public static void registerAttendees() {
    //Given
    Test.setMock(HttpCalloutMock.class, new ReservationCalloutMock(201));

    Account salesforce = (Account) TestDataFactory.createSObject(
      'Account',
      new Map<String, Object>{ 'Name' => 'Salesforce' }
    );

    Contact contact1 = (Contact) TestDataFactory.createSObject(
      'Contact',
      new Map<String, Object>{
        'LastName' => 'Contact 1',
        'AccountId' => salesforce.Id,
        'Email' => 'contact1@gmail.com'
      }
    );

    Case request = (Case) TestDataFactory.createSObject(
      'Case',
      new Map<String, Object>{
        'Origin' => 'Web',
        'Subject' => 'Event Booking',
        'Description' => 'Book Spots for Company A1 & their 3 employees',
        'AccountId' => salesforce.Id
      }
    );
    //When
    Test.startTest();
    request.Status = 'Closed';
    update request;
    Test.stopTest();
    //Then
    List<Log__c> logs = [SELECT Message__c, Method__c FROM Log__c];
    System.assert(logs.size() == 0, 'error occured & was logged');
  }
}