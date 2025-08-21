import { LightningElement } from 'lwc';
import getEmpresa from '@salesforce/apex/calloutAPIReceita.usoLWC';

export default class BuscaPorCnpj extends LightningElement {
    cnpj = '';
    empresa = null;
    error = null;

    handleCnpjChange(event) {
        this.cnpj = event.target.value;
        this.error = null;
    }

    async handleBuscarClick() {
        if (!this.cnpj || this.cnpj.trim() === '') {
            this.error = 'Por favor, digite um CNPJ válido.';
            this.empresa = null;
            return;
        }

        try {
            const resultado = await getEmpresa({ CNPJ: this.cnpj });
            this.empresa = resultado;
            this.error = null;
        } catch (error) {
            this.empresa = null;
            if (error && error.body && error.body.message) {
                this.error = error.body.message;
            } else if (error && error.message) {
                this.error = error.message;
            } else {
                this.error = 'Erro desconhecido ao buscar empresa.';
            }
        }
    }

    limparPesquisa() {
        this.cnpj = '';
        this.empresa = null;
        this.error = null;
    }

    get mostrarFormulario() {
        return !this.empresa;
    }
}
