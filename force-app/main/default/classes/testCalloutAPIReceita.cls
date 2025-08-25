@isTest
public class testCalloutAPIReceita {
    
    @isTest static void testCalloutOk(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        HttpResponse res = calloutAPIReceita.calloutApi('06862627000138');
        
        String respostaAtual = '{"abertura": "20/06/1969","situacao": "ATIVA","tipo": "MATRIZ","fantasia": "ARMAZEM PARAIBA","natureza_juridica": "205-4 - Sociedade Anônima Fechada","numero": "607","municipio": "TERESINA","bairro": "CENTRO","uf": "PI","email": "rodolfo@armazemparaiba.com.br","telefone": "(86) 3216-5882/ (86) 3216-5874","status":"OK","cnpj": "06.862.627/0001-38"}';
        String respostaEsperada = res.getBody(); 
        system.assertEquals(respostaAtual, respostaEsperada);
        system.assertEquals(200, res.getStatusCode());        
    }
    
    @isTest static void testCalloutCNPJInvalido(){
        
        Test.startTest();
        try{
        HttpResponse res = calloutAPIReceita.calloutApi('0');
    	
        }catch(funcoesApoioCalloutApiReceita.ErrorException e){
            system.assertEquals('CNPJ tem formato inválido.', e.getMessage(), 'Deveria informar que o CNPJ tem formato inválido.');
        }
        Test.stopTest();
    }
    
    @isTest static void testCalloutCNPJNaoEncontrado(){
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorCNPJNaoEncontrado());
        
        Test.startTest();
        
        HttpResponse res = null;
        try{
        res = calloutAPIReceita.calloutApi('06862627000133');
            
        }catch(funcoesApoioCalloutApiReceita.ErrorException e){
        system.assertEquals('CNPJ não encontrado.', e.getMessage(), 'Deveria informar que o CNPJ não foi encontrado.');
        }
    	Test.stopTest();
    }
    
    
    @isTest static void testCalloutCodigoRetornoDiferenteDe200(){
      
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorError());
		
		Test.startTest();
        
        HttpResponse res = null;
        
        try{
        res = calloutAPIReceita.calloutApi('06862627000138');
            
        }catch(funcoesApoioCalloutApiReceita.ErrorException e){
        system.assertEquals('Status do callout diferente do esperado: Status - 500', e.getMessage(), 'Deveria informar que o status é diferente de 200.');
        }
    	Test.stopTest();
		        
    }
    
    
	@isTest	static void testUsoLWC() {
    // Define o mock da resposta HTTP
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    Test.startTest();

    Empresa empresa = calloutAPIReceita.usoLWC('06862627000138');

    Test.stopTest();

    // Valida os dados retornados
    System.assertNotEquals(null, empresa, 'A empresa não deveria ser nula');
    System.assertEquals('ARMAZEM PARAIBA', empresa.fantasia, 'O nome fantasia deveria ser ARMAZEM PARAIBA');
    System.assertEquals('TERESINA', empresa.municipio, 'O município deveria ser TERESINA');
    System.assertEquals('PI', empresa.uf, 'O estado deveria ser PI');
	}
    
    
	@isTest	static void testUsoFlow() {
    // Define o mock da resposta HTTP
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    // Prepara a entrada simulada do Flow
    List<String> listaCNPJs = new List<String>{'06862627000138'};

    Test.startTest();

    List<Empresa> empresas = calloutAPIReceita.usoFlow(listaCNPJs);

    Test.stopTest();

    // Valida os dados retornados
    System.assertEquals(1, empresas.size(), 'Deveria retornar uma empresa');
    Empresa empresa = empresas[0];
    System.assertNotEquals(null, empresa, 'A empresa não deveria ser nula');
    System.assertEquals('ARMAZEM PARAIBA', empresa.fantasia, 'O nome fantasia deveria ser ARMAZEM PARAIBA');
    System.assertEquals('TERESINA', empresa.municipio, 'O município deveria ser TERESINA');
    System.assertEquals('PI', empresa.uf, 'O estado deveria ser PI');
	}

  //=========================Fake responses=========================
    
    public class MockHttpResponseGenerator implements HttpCalloutMock{
        
        public httpResponse respond(HTTPRequest req){
            
            System.assertEquals('GET', req.getMethod());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setBody('{"abertura": "20/06/1969","situacao": "ATIVA","tipo": "MATRIZ","fantasia": "ARMAZEM PARAIBA","natureza_juridica": "205-4 - Sociedade Anônima Fechada","numero": "607","municipio": "TERESINA","bairro": "CENTRO","uf": "PI","email": "rodolfo@armazemparaiba.com.br","telefone": "(86) 3216-5882/ (86) 3216-5874","status":"OK","cnpj": "06.862.627/0001-38"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    public class MockHttpResponseGeneratorCNPJNaoEncontrado implements HttpCalloutMock{
        
        public httpResponse respond(HTTPRequest req){
            
            System.assertEquals('GET', req.getMethod());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setBody('{"status": "ERROR","message": "CNPJ inválido"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
        public class MockHttpResponseGeneratorError implements HttpCalloutMock{
        
        public httpResponse respond(HTTPRequest req){
            
            System.assertEquals('GET', req.getMethod());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setBody('');
            res.setStatusCode(500);
            return res;
        }
    }
}