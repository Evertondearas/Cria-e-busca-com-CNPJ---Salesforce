public class funcoesApoioCalloutApiReceita {
    
	public class CalloutAPIException extends Exception {}//Classe para que possamos exetender as excessões que usaremos em caso de erro.
	public class ErrorException extends Exception{}//Classe para que possamos exetender as excessões que usaremos em caso de erro genérico.

    //Deserializa json em formato de objeto customizado(Empresa).
    public static Empresa deserializa(String jsonString) {
        return (Empresa) JSON.deserialize(jsonString, Empresa.class);
    }
    
    //Limpa e formata CNPJ, pois para fazer a consulta de api a string precisa estar sem os caracteres presentes no CNPJ('.', '-', '/').
    public static String limpaEValidaCNPJ(String CNPJ) {
        if (String.isBlank(CNPJ)) {//Checa se é vazia.
            throw new ErrorException('CNPJ de entrada está vazio ou nulo.');
        }
        String cleanedCNPJ = CNPJ.replaceAll('[^0-9]', ''); //Retira os caracteres e deixa apenas os números.
        if (cleanedCNPJ.length() == 14) {//Checa tamanho.
            return cleanedCNPJ;
        } else {
           throw new ErrorException('CNPJ inválido: não possui 14 dígitos após limpeza. Comprimento: ' + cleanedCNPJ.length());
        }
    }
}