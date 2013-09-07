trigger StationLineTrigger on Station_Line__c (before insert, before update) {
    Map<Integer, ID> c = new Map<Integer, ID>();
    for (Station_Company__c i : [Select Id, CompanyEXID__c From Station_Company__c]) {
        c.put(i.CompanyEXID__c.intValue(), i.Id);
    }
    for (Station_Line__c i : Trigger.new) {
        i.Station_Company__c = c.get(i.CompanyEXID__c.intValue());
        System.debug('CompanyEXID: ' + c.get(i.CompanyEXID__c.intValue()));
    }
}