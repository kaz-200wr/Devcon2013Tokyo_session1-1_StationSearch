@isTest
private class StationTriggerTest {
    static testMethod void commonTest() {
        Test.startTest();
        Station_Company__c c = new Station_Company__c(
            Name = 'c',
            CompanyEXID__c = 1
        );
        insert c;
        Station_Line__c l = new Station_Line__c(
            Name = 'l',
            CompanyEXID__c = 1,
            LineEXID__c = 1
        );
        insert l;
        Station__c s = new Station__c(
            Name = 'test',
            StationEXID__c = 1,
            LineEXID__c = 1
        );
        insert s;
        
        Test.stopTest();
    }
}