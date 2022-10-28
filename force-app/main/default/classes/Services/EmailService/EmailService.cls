public class EmailService {
  public static void sendEmails(List<Contact> contacts) {
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    EmailTemplate template = [
      SELECT Subject, Body
      FROM EmailTemplate
      WHERE DeveloperName = 'ReservationIsSuccess'
      LIMIT 1
    ];
    for (Contact contact : contacts) {
      contact.SendEmail__c = false;
      Messaging.SingleEmailMessage mail = composeEmailMessage(
        contact.Id,
        template.Id
      );
      mails.add(mail);
    }
    if (!mails.isEmpty()) {
      Messaging.sendEmail(mails);
    }
  }

  private static Messaging.SingleEmailMessage composeEmailMessage(
    Id contactId,
    Id templateId
  ) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setTemplateId(templateId);
    mail.setTargetObjectId(contactId);
    return mail;
  }
}
