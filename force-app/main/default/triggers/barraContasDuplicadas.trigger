trigger barraContasDuplicadas on Account (before insert) {
	
    Set<String> cnpjs = new Set<String>();
    for(Account acct: trigger.new){
        if(acct.CNPJ__c != null){
        	cnpjs.add(acct.CNPJ__c);
        }
    }
    
    if(!cnpjs.isEmpty()){
        List<Account> accts = [select id, name, CNPJ__c from Account where CNPJ__c in :cnpjs];
        if(!accts.isEmpty()){
            for(Account acct: trigger.new){
                for(Account acct2: accts){
                    if(acct.CNPJ__c == acct2.CNPJ__c){
                        acct.addError('Não é possível criar a conta. Já existe uma conta com o CNPJ ' + acct2.CNPJ__c);
                        break;
                    }
                }
            }
        }
    }
}