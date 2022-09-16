vet%dw 2.0 
input data application/csv
output application/apex
records map(record) -> {
    ExternalId__c: record.patient_id,
    ClientId__c: record.client_id,
    Type__c: record.type,
    Date__c: record.date,
    Details__c: record.details,
    Treatment__c: record.treatment,
    Resolution__c: record.resolution,
    Instructions__c: record.instructions,
    IsVaccination__c: record.is_vaccination,
    Vaccine__c: record.vaccine
} as Object {class: "VetRecord__c"}