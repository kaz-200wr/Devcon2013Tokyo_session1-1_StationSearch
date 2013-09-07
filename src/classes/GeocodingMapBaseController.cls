public abstract class GeocodingMapBaseController {
    public String json_str {get;set;}
    public String name {get;set;}
    public String address {get;set;}
    public Integer all_count {get;set;}
    public String maxrecords {get;set;}

    protected String soql_base;
    public String sobject_name;
    protected String name_field_name;
    public List<String> fields;

    public GeocodingMapBaseController(String sobject_name) {
        this(sobject_name, 'Name');
    }

    public GeocodingMapBaseController(String sobject_name, String name_field_name) {
        this(sobject_name, name_field_name, new List<String>());
    }

    public GeocodingMapBaseController(String sobject_name, String name_field_name, List<String> fields) {
        this.json_str = '[]';
        this.name = '';
        this.address = '';
        this.maxrecords = '100';
        this.sobject_name = sobject_name;
        this.name_field_name = name_field_name;
        this.fields = fields;

        this.soql_base = 'Select ' + this.name_field_name + ', lat__c, lng__c, GeocodingAddress__c';
        for (String f : fields) {
            this.soql_base += ', ' + f;
        }
        this.soql_base += ' From ' + this.sobject_name;
    }

    public SelectOption[] options {
        get{
            return new SelectOption[]{
                new SelectOption('100', '100'),
                new SelectOption('500', '500'),
                new SelectOption('1000', '1000'),
                new SelectOption('4000', '4000')
            };
        }
    }

    protected virtual String searchWhere() {
        return '';
    }

    protected virtual String searchOrder() {
        return '';
    }

    public virtual void search() {
        String where_exp = ' Where lat__c != NULL And lng__c != NULL ';
        String where_exp_add = searchWhere();
        String order_by = searchOrder();
        String option_exp = ' Limit ' + maxrecords;

        if (name != null && name != '') where_exp += ' And ' + name_field_name + ' like \'%' + String.escapeSingleQuotes(name) + '%\'';
        if (address != null && address != '') where_exp += ' And GeocodingAddress__c like \'%' + String.escapeSingleQuotes(address) + '%\'';
        if (where_exp_add != '') where_exp += ' And (' + where_exp_add + ')';
        if (order_by != '') option_exp = ' Order By ' + order_by + option_exp;
        System.debug('SOQL: ' + soql_base + where_exp + option_exp);
        List<sObject> records = Database.query(soql_base + where_exp + option_exp);
        createJson(records);
    }

    protected virtual void createJson(List<sObject> records) {
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartArray();
        for (sObject s : records) {
            gen.writeStartObject();
                gen.writeStringField('id', s.Id);
                gen.writeStringField('name', s.get(name_field_name) != null ? (String)s.get(name_field_name) : '');
                gen.writeStringField('address', s.get('GeocodingAddress__c') != null ? (String)s.get('GeocodingAddress__c') : '');
                gen.writeNumberField('lat', ((Decimal)s.get('lat__c')).doubleValue());
                gen.writeNumberField('lng', ((Decimal)s.get('lng__c')).doubleValue());
                extraJsonField(gen, s);
            gen.writeEndObject();
        }
        gen.writeEndArray();

        json_str = gen.getAsString();
    }

    protected virtual void extraJsonField(JSONGenerator gen, sObject s) {
    }
}