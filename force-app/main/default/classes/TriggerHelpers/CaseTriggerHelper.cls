public without sharing class CaseTriggerHelper {
  private static final String CLOSED = 'Closed';

  public static void registerAttendees(List<Case> reservations) {
    for (Case reservation : reservations) {
      if (CLOSED.equals(reservation.Status)) {
        ExternalSystemService.registerAttendees(reservation);
      }
    }
  }

  public static void validateReservation(List<Case> reservations) {
    for (Case reservation : reservations) {
      if (reservation.AccountId != null) {
        //maybe use agregate SOQL
        AggregateResult[] groupedResults = [
          SELECT AccountId, Count(Name) numberOfContacts
          FROM Contact
          GROUP BY AccountId
          HAVING AccountId = :reservation.AccountId
        ];

        Integer numberOfContacts = groupedResults.size() == 1
          ? (Integer) groupedResults[0].get('numberOfContacts')
          : 0;

        if (numberOfContacts == 0) {
          reservation.addError(
            'You cannot create a request for accounts without contacts'
          );
        } else {
          switch on reservation.Origin {
            when 'Web' {
              if (numberOfContacts >= 2) {
                reservation.addError(
                  'Web request are only allowed to have one attendee'
                );
              }
            }
            when 'Phone' {
              if (numberOfContacts >= 4) {
                reservation.addError(
                  'Phone request are only allowed to have three attendee'
                );
              }
            }
          }
        }
      } else {
        reservation.addError(
          'You cannot create a request without attaching an account'
        );
      }
    }
  }
}
