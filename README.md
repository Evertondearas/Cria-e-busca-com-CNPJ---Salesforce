📄 Busca e Criação de Conta por CNPJ (Salesforce Flow + Apex Callout)
Este projeto demonstra a criação de uma solução de integração de dados no Salesforce utilizando o Flow em conjunto com uma Classe Apex Invocável para realizar um callout (chamada externa) à API pública da ReceitaWS e buscar informações cadastrais de empresas brasileiras pelo CNPJ.

✨ Funcionalidades Principais
Validação e Limpeza de CNPJ: O CNPJ inserido pelo usuário é limpo e validado (tamanho de 14 dígitos) antes da chamada à API.

Busca em API Externa: Realiza uma chamada GET segura à ReceitaWS para buscar dados atualizados da empresa.

Tratamento de Erros Eficaz: Captura e trata exceções de forma clara, apresentando mensagens amigáveis ao usuário final no Flow em caso de CNPJ inválido, não encontrado ou falha na comunicação.

Criação de Conta: Após a busca bem-sucedida, o Flow permite a criação de um registro de Account (Conta) preenchido automaticamente com os dados da Receita Federal.

Prevenção de Duplicidade: Verifica a existência de uma conta com o mesmo CNPJ antes de criar uma nova.

💻 Componentes e Metadados
Tipo de Metadado	Nome do Arquivo / API Name	Função
Flow	Cria_conta_por_CNPJ_V17	Orquestra a interação com o usuário, chama o Apex e executa a lógica de criação de conta e tratamento de falhas.
Apex Class	calloutAPIReceita	Contém o método @invocableMethod (usoFlow) que é chamado pelo Flow, e o método principal (calloutApi) que executa a chamada HTTP.
Apex Class	funcoesApoioCalloutApiReceita	Contém funções utilitárias: limpeza/validação de CNPJ e classes de exceção customizadas (ErrorException e CalloutAPIException).
Apex Class	Empresa	Classe Wrapper (Contêiner) para desserializar a resposta JSON da API da ReceitaWS em um objeto Apex fácil de usar.
Apex Class	testCalloutAPIReceita	Classe de teste para garantir a cobertura de código dos callouts HTTP (simulando a resposta da API com um Mock).

Exportar para as Planilhas
🚀 Configuração e Implantação
Para utilizar este projeto em sua própria Organização do Salesforce, siga os passos abaixo:

1. Configuração de Credenciais Remotas
O Salesforce exige que todos os callouts externos sejam explicitamente autorizados.

No Salesforce, vá para Setup (Configuração) > Security (Segurança) > Remote Site Settings (Configurações de Site Remoto).

Clique em New Remote Site (Novo Site Remoto).

Preencha os campos:

Remote Site Name: ReceitaWS_API

Remote Site URL: https://receitaws.com.br

Marque Active e Salve.

2. Deploy do Código (Usando SF CLI)
Com o projeto clonado e sua org conectada ao VS Code, execute o comando de implantação no terminal:

# O comando abaixo envia todos os arquivos da pasta 'force-app'
# e executa a classe de teste para garantir a cobertura de código
sf project deploy start --metadata-dir force-app --test-level RunSpecifiedTests --tests testCalloutAPIReceita
3. Execução do Flow
No Salesforce, vá para Setup (Configuração) > Process Automation (Automação de Processos) > Flows.

Encontre e clique no Flow Cria conta por CNPJ (V17).

Você pode ativá-lo e adicioná-lo a uma página do Lightning (como a Página Inicial ou a página de Registro de Conta) usando um componente Flow.

🧪 Testes
Para garantir que o código Apex (especialmente o callout) atenda aos requisitos de cobertura de código do Salesforce, a classe de teste deve ser executada.

Executar os Testes:

sf apex run test --class-names testCalloutAPIReceita
A classe testCalloutAPIReceita simula uma resposta de sucesso (HTTP 200) e testa a validação de erro do CNPJ, garantindo alta cobertura de código.

<img width="1919" height="868" alt="image" src="https://github.com/user-attachments/assets/73a8ff15-99ca-4199-b44e-5091746a0fb9" />
