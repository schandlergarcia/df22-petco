@isTest
public class VetRecordsInvocable_TEST {

  @isTest
  static void testGetMedicalRecordsInvocable() {
    // Get Test data from Static Resource
    String csvData = [SELECT Body FROM StaticResource WHERE Name = 'VetRecordsTestData' LIMIT 1].Body.toString();
    PetcoMockFactory mock = new PetcoMockFactory(200, 'OK', csvData, new Map<String, String>());

    // Set the mock and run the test
    Test.setMock(HttpCalloutMock.class, mock);
    Test.startTest();
    VetRecordsInvocable.Input variables = new VetRecordsInvocable.Input();
    variables.externalId = 'test';
    VetRecordsInvocable.getVetRecords(new List<VetRecordsInvocable.Input>{ variables });
    Test.stopTest();

    List<VetRecord__c> vetRecordResult = [SELECT ExternalId__c, IsGoodDog__c FROM VetRecord__c ];
    Assert.areEqual(10, vetRecordResult.size(), 'Expected CSV data size');
    Assert.isNotNull(vetRecordResult[0].ExternalId__c, 'The External Id was not set');
    Assert.isTrue(vetRecordResult[0].IsGoodDog__c, 'Who\'s a good dog?');    
  }
}