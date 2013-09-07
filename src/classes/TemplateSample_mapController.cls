public class TemplateSample_mapController{
    public TemplateSample_mapController() {}

    @RemoteAction
    public static List<Station__c> getStationRecs(){
        return [select id, name, Location__latitude__s, Location__longitude__s, Address__c from Station__c order by Name limit 10000];
    }
}