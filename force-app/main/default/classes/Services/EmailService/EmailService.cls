public without sharing class EmailService {
  public static void sendEmail(String name, String email) {
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.toAddresses = new List<String>{ email };
    message.subject = 'Reservation Status';
    message.plainTextBody =
      'Congratulation ' +
      name +
      ' ! your reservation is a success. We can\'t wait to see you.';

    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{
      message
    };
    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

    if (!results[0].success) {
      Log.error('The email failed to send: ' + results[0].errors[0].message);
    }
  }
}
