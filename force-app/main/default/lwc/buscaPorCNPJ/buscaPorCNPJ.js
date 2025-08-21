import { LightningElement } from 'lwc';
import getEmpresasList from '@salesforce/apex/calloutAPIReceita.usoLWC';

export default class BuscaPorCNPJ extends LightningElement {
    
    CNPJInput;
    empresas;
    error;

    handleCnpjChange(event){
        this.CNPJInput = event.target.value;
    }

    async handleBuscarClick(){
        if(this.CNPJInput){
            await this.buscaEmpresa(this.CNPJInput);
        }else {
            this.error = { message: 'Por favor, digite um CNPJ.' };
            this.empresas = undefined;
        }
    } 
    
    async buscaEmpresa(CNPJ){
        try {
             this.empresas = await getEmpresasList({CNPJ: CNPJ});
             this.error = undefined;
             console.log('Empresa encontrada:', this.empresas);
            }    
        catch(error) {
            this.empresas = undefined;
            this.error = error;
            console.log('Erro na busca: ', error.message);
        }
    }
}