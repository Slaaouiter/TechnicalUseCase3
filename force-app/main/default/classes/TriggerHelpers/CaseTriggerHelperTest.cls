@isTest
private class CaseTriggerHelperTest {
  @isTest
  public static void validateReservationRefusesCaseCreationWhenAnAccountIsNotAttachedToACase() {
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
      'You cannot create a request without attaching an account',
      result.getErrors()[0].getMessage(),
      'The error message should be : You cannot create a request without attaching an account'
    );
  }

  @isTest
  public static void validateReservationRefusesCaseCreationWhenNoContactIsAttachedToAnAccount() {
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
      'You cannot create a request for accounts without contacts',
      result.getErrors()[0].getMessage(),
      'The error message should be : You cannot create a request for accounts without contacts'
    );
  }

  @isTest
  public static void validateReservationAcceptsbookingEventFromPhoneWithLessThan4Contacts() {
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
      Description = 'Book Spots for Company A1 & their 3 employees',
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
  public static void validateReservationRefusesEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases() {
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
      Description = 'Book Spots for Company A1 & their 4 employees',
      AccountId = salesforce.ID
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
      'Phone request are only allowed to have three attendee',
      result.getErrors()[0].getMessage(),
      'The error message should be : Phone request are only allowed to have three attendee'
    );
  }

  @isTest
  public static void validateReservationAcceptsBookingEventFromTheWebWithLessThan2Accounts() {
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
      Description = 'Book One Spot for Company A1',
      AccountId = salesforce.ID
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
  public static void validateReservationRefusesEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases() {
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
      Description = 'Book Spots for Company A1 & their 3 employees',
      AccountId = salesforce.ID
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
      'Web request are only allowed to have one attendee',
      result.getErrors()[0].getMessage(),
      'The error message should be : Web request are only allowed to have one attendee'
    );
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
        'AccountId' => salesforce.ID
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
        'AccountId' => salesforce.ID
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
