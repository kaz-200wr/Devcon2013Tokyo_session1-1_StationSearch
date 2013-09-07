trigger StationTrigger on Station__c (before insert, before update) {
    Map<Integer, ID> l = new Map<Integer, ID>();
    for (Station_Line__c i : [Select Id, LineEXID__c From Station_Line__c]) {
        l.put(i.LineEXID__c.intValue(), i.Id);
    }
    for (Station__c  i : Trigger.new) {
        i.Station_Line__c = l.get(i.LineEXID__c.intValue());
    }
}