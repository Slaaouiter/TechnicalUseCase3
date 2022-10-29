public class HttpUtils {
  public static void notifyExternalSystem(List<Contact> contacts) {
    for (Contact contact : contacts) {
      registerContact(contact);
    }
  }
  private static void registerContact(Contact contact) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:Reservation_System_API');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody('{"name":"' + contact.Name + '-' + contact.Email + '}');
    HttpResponse response = http.send(request);
    if (response.getStatusCode() != 201) {
      Log.error(
        'The status code returned was not expected: ' +
        response.getStatusCode() +
        ' ' +
        response.getStatus()
      );
    } else {
      contact.SendEmail__c = true;
      contact.NotifyExternalSystem__c = false;
    }
  }
}
