public with sharing class VetRecordsInvocable {
  @InvocableMethod(callout=true label='Get Vet Records')
  public static void getVetRecords(List<Input> input) {
    Input externalId = input.get(0);
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:VetcoRecordsAPI/externalId');
    req.setMethod('GET');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    List<VetRecord__c> vetRecords = convertCsvToMedicalRecord(res.getBody());

    insert vetRecords as user;
  }

  private static List<VetRecord__c> convertCsvToMedicalRecord(String csvResult) {
    // Uses the ./src/dw/vetRecordsCSVtoSObject.dwl script to convert the csv returned into List<SObject>
    dataweave.Script dwscript = DataWeave.Script.createScript('vetRecordsCSVtoSObject');
    DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{ 'records' => csvResult });
    List<VetRecord__c> vetRecords = (List<VetRecord__c>)dwresult.getValue();
    return vetRecords;
  }

  public class Input {
    @InvocableVariable
    public String externalId;
  }
}