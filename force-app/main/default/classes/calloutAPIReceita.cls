public class calloutAPIReceita {    
        public static HttpResponse calloutApi (String CNPJ){

            //checa se o CNPJ tem formato válido.
            String CNPJLimpo = funcoesApoioCalloutApiReceita.limpaEValidaCNPJ(CNPJ); 
               
                //configurações da chamada
                String endpoint = 'https://receitaws.com.br/v1/cnpj/' + CNPJLimpo;
                Http http = new Http();
                HttpRequest request = new httpRequest();
                request.setEndpoint(endpoint);
                request.setMethod('GET');
                request.setTimeout(60000); 
                
                //Tenta fazer o callout. 
                try{
                    httpResponse response = http.send(request);    
                    //Se o callout for bem sucedido e o status for 200 (OK).
                    if(response.getStatusCode() == 200 && !response.getBody().contains('"status": "ERROR"')){
                        return response;
                        
                    }//Se o status for 200, mas o cnpj não for achado. 
                    else if(response.getStatusCode() == 200 && response.getBody().contains('"status": "ERROR"'))
                       throw new funcoesApoioCalloutApiReceita.ErrorException('CNPJ não encontrado.');
                        
                    else//Se a chamada foi feita, mas o status é diferente de 200 (Retornou algo diferente do esperado).
                        throw new funcoesApoioCalloutApiReceita.ErrorException('Status do callout diferente do esperado: Status - '+response.getStatusCode());
                        
                }catch(Calloutexception e){//Caso venha outro status que não é 200.
                    throw new funcoesApoioCalloutApiReceita.CalloutAPIException('Falha na comunicação com a API da ReceitaWS: ' + e.getMessage());
                }
            
          }
        
        @AuraEnabled(cacheable=true)//usar no lwc.
        public static Empresa usoLWC(String CNPJ){
            
            HttpResponse response = calloutAPIReceita.calloutApi(CNPJ);
            Empresa empresa = funcoesApoioCalloutApiReceita.deserializa(response.getBody());
            system.debug(empresa);	
            return empresa;
        }
    
        @invocableMethod(label='Busca empresa por CNPJ FLOW' description='Método que busca empresa por CNPJ na API da receita, feito para flow')	
        public static List<Empresa> usoFlow(List<String> CNPJ){
        
            HttpResponse response = calloutAPIReceita.calloutApi(CNPJ[0]);        
            List<Empresa> empresas = new List<Empresa>(); 
            empresas.add(funcoesApoioCalloutApiReceita.deserializa(response.getBody()));
            return empresas;
                
        }
    }