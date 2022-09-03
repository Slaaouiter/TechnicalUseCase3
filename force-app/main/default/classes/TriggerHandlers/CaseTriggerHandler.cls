public class CaseTriggerHandler extends TriggerHandler {
  private List<Case> oldCases;
  private List<Case> newCases;
  private Map<Id, Case> oldIdToCase;
  private Map<Id, Case> newIdToCase;

  public CaseTriggerHandler() {
    oldCases = (List<Case>) Trigger.old;
    newCases = (List<Case>) Trigger.new;
    oldIdToCase = (Map<Id, Case>) Trigger.oldMap;
    newIdToCase = (Map<Id, Case>) Trigger.newMap;
  }

  public override void beforeInsert() {
    CaseTriggerHelper.validateReservation(newCases);
  }

  public override void afterUpdate() {
    CaseTriggerHelper.registerAttendees(newCases);
  }
}
