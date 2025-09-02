@isTest
public class testBarraContasDuplicadas {

    @isTest static void testSucesso(){
    	Account acct = new Account(name ='Conta teste 1', CNPJ__C = '00.000.000/0000-01');
        
        Test.startTest();
        
        Database.SaveResult sr = Database.insert(acct, false);
    	System.assert(sr.isSuccess());
        
        Test.StopTest();
   
    }
    
      @isTest static void testCNPJDuplicado() {

        Account existingAcc = new Account(
            Name = 'Conta de Teste Existente',
            CNPJ__c = '11.111.111/1111-11'
        );
        insert existingAcc;

        Account duplicateAcc = new Account(
            Name = 'Conta de Teste Duplicada',
            CNPJ__c = '11.111.111/1111-11'
        );
        
        Test.startTest();
        
        Database.SaveResult sr = Database.insert(duplicateAcc, false);

        Test.stopTest();

        System.assert(!sr.isSuccess());
        System.assertEquals('Não é possível criar a conta. Já existe uma conta com o CNPJ 11.111.111/1111-11', sr.getErrors()[0].getMessage());
    }
}