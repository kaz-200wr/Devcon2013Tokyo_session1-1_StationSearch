public class GeocodingStationMapController extends GeocodingMapBaseController {
    public Double center_lat {get;set;}
    public Double center_lng {get;set;}

    protected override String searchOrder() {
        return 'DISTANCE(Location__c, GEOLOCATION(' + center_lat + ', ' + center_lng + '), \'km\')';
    }

    public GeocodingStationMapController() {
        super('Station__c');
        center_lat = 35.681391;
        center_lng = 139.766103;
    }
}