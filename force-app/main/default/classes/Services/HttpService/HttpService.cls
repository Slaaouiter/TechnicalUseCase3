public without sharing class HttpService {
  @future(callout=true)
  public static void registerAttendee(String name, String email) {
    HttpResponse response = callExternalReservationSystem(name, email);
    if (response.getStatusCode() != 201) {
      Log.error(
        'The status code returned was not expected: ' +
        response.getStatusCode() +
        ' ' +
        response.getStatus()
      );
    } else {
      EmailService.sendEmail(name, email);
    }
  }
  public static HttpResponse callExternalReservationSystem(
    String name,
    String email
  ) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:Reservation_System_API');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody('{"name":"' + name + '-' + email + '}');
    return http.send(request);
  }
}
