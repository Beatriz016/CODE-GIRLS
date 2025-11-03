# # Laboatorio 05

Neste Arquivo esta documentado meus aprendizados e insights relacionado a Automatização de Tarefas.


## ⚙️ Executando Tarefas Automatizadas com Lambda Function e S3


<h3>Principais Vantagens do S3:</h3>

* **Durabilidade:** Altamente confiavel, com redundancia para proteger contra falhas.
* **Disponibilidade:** Garante acesso continuo aos dados.
* **Escalabilidade:** Ajusta automaticamente a capacidade de armazenamento com base nas necessidades.
* **Segurança:** Oferece criptografia, controle de acesso e monitoramento de atividades.



<h3>Principais Vantagens do Lambda:</h3>

* **Execução sob demanda:** Ocódigo é executado apenas quando necessario, respondendo a eventos.
* **Escalabilidade Automatica:** Ajusta a capacidade automaticamente com base no número de eventos.
* **Custo Eficiente:** Cobra apenas pelo tempo de execução e pela quantidade de solicitações.
* **Integração com outros serviços AWS:** Funciona como um conectos entre diversos serviços da AWS, como S3, DynamoDB, API Gateway.

<br>
<br>

## LocalStack (AWS local)


<h3>Tarefas para Configuração</h3>


1. Criar o bucket S3: Configure um bucket chamado notas-fiscais-upload
2. Criar a tabela no DynamoDB: Nome NotasFiscais, com chave primária id.
3. Criar uma Lambda Function: Configure as permissões para acesso ao S3 e DynamoDB.
4.  Criar o trigger do S3: Configure o bucket para disparar a Lambda ao fazer upload de arquivos

---

<br>
<br>

1) S3 - Criar o notas-fiscais-upload:
```text
awslocal s3api create-bucket --bucket notas-fiscais-upload
awslocal s3api list-buckets
```

2) DynamoDB - criar a tabela NotasFiscais:
```text
aws dynamodb create-table --endpoint-url=http://localhost:4566 --table-name NotasFiscais \
--attribute-definitions AttributeName=id,AttributeType=S --key-schema AttributeName=id,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```
Verificar tabela: 
```text
aws dynamodb list-tables --endpoint-url=http://localhost:4566
```
* Download NoSQL Workbench for DynamoDB, para fazer querys ou outro a sua escolha: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.settingup.html

Script para gerar o arquivo notas_fiscais.json, na pasta codigo
Para executar: python gerar_dados.py - ira gerar um arquivo fake 


Enviar arquivo para S3:  
```text
aws s3 cp notas_fiscais.json s3://notas-fiscais-upload/notas_fiscais.json --endpoint-url=http://localhost:4566  
```

3. Lambda Function:  

```text
aws lambda create-function \  
--function-name ProcessarNotasFiscais \  
--runtime python3.9 \  
--role arn:aws:iam::000000000000:role/lambda-role \  
--handler grava_db.lambda_handler \  
--zip-file fileb://grava_db.zip \  
--endpoint-url=http://localhost:4566
```
  
Configurar o trigger S3:  
```text
aws lambda add-permission --function-name ProcessarNotasFiscais --statement-id s3-trigger --action \
"lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn arn:aws:s3:::notas-fiscais-upload \
--endpoint-url=http://localhost:4566  
```
   

Envie um arquivo JSON para o bucket S3:
```text  
aws s3 cp notas_fiscais.json s3://notas-fiscais-upload --endpoint-url=http://localhost:4566  
```
Resumo:  
Empacote o código em .zip.  
Crie a função Lambda no Localstack.  
Configure o bucket S3 para disparar a Lambda.  
Envie um arquivo para o S3.  
Verifique os logs e os dados inseridos no DynamoDB.  

---
<br>
<br>
<br>
---

<h3>Tarefas para Configuração - Hands On:</h3>

> Baixar Localstack: https://docs.localstack.cloud/getting-started/installation/
> Opção → Localstack Desktop: https://docs.localstack.cloud/user-guide/tools/localstack-desktop/

Após instalação, validar: localstack --version
Deverá exibir a versão instalada

Se você estiver usando Docker, execute o Localstack com o comando abaixo:
docker run -d --name localstack -p 4566:4566 -p 4571:4571 -e SERVICES=ALL -e DEBUG=1 -v /var/run/docker.sock:/var/run/docker.sock localstack/localstack

Se instalou com LocalStack CLI, você pode atualizar ou validar as informações:
Entendido! Para atualizar apenas o **Localstack CLI** instalado no seu sistema via **PowerShell**, siga os passos abaixo:

> Instale novamente a versão mais recente via PIP

pip install localstack

> Verifique a instalação

Após a instalação, verifique se a atualização foi concluída corretamente:
localstack --version

> Teste o CLI

Com o Localstack CLI atualizado, você pode tentar o comando novamente:
localstack update all

Para iniciar:  
localstack start  

Depois de iniciado, o Localstack estará disponível no endereço http://localhost:4566. Use o comando a seguir para verificar o status:  
    Invoke-RestMethod -Uri "http://localhost:4566/_localstack/health"  

> Configurar o AWS CLI local  

Digite no prompt: aws configure  

environment:  
$env:AWS_ACCESS_KEY_ID="test"  
$env:AWS_SECRET_ACCESS_KEY="test"  
$env:AWS_DEFAULT_REGION="us-east-1"  
$env:AWS_DEFAULT_OUTPUT=json  

<h3>Atenção: as credenciais NÃO PRECISAM SER VÁLIDAS, mas devem ser definidas!</h3>



1. Criar o bucket S3: Configure um bucket chamado notas-fiscais-upload
2. Criar a tabela no DynamoDB: Nome NotasFiscais, com chave primária id.
3. Criar uma Lambda Function: Configure as permissões para acesso ao S3 e DynamoDB.
4.  Criar o trigger do S3: Configure o bucket para disparar a Lambda ao fazer upload de arquivos

---

<br>
<br>

Criar a função Lambda:  
```text
aws lambda create-function --function-name ProcessarNotasFiscais --runtime python3.9 --role arn:aws:iam::000000000000:role/lambda-role --handler grava_db.lambda_handler --zip-file fileb://lambda_function.zip --endpoint-url=http://localhost:4566  
```
Verificar se a função Lambda foi criada:  
```
aws lambda list-functions --endpoint-url=http://localhost:4566  
```
Criar o bucket S3:  
```text
awslocal s3api create-bucket --bucket notas-fiscais-upload  
```
Conceder permissão ao S3 para invocar a função Lambda:  
```text
aws lambda add-permission --function-name ProcessarNotasFiscais --statement-id s3-trigger-permission --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn "arn:aws:s3:::notas-fiscais-upload" --endpoint-url=http://localhost:4566  
```
Configurar a notificação no bucket S3 - Role:  
```text
aws s3api put-bucket-notification-configuration --bucket notas-fiscais-upload --notification-configuration file://notification_roles.json --endpoint-url=http://localhost:4566  
```
Validar a notificação no bucket S3 - Role:
```text  
aws s3api get-bucket-notification-configuration --bucket <nome-do-bucket> --endpoint-url=http://localhost:4566  
```
```
aws s3api get-bucket-notification-configuration --bucket notas-fiscais-upload --endpoint-url=http://localhost:4566  
```


1) S3 - Criar o notas-fiscais-upload:
```text
awslocal s3api create-bucket --bucket notas-fiscais-upload
awslocal s3api list-buckets
```

2) DynamoDB - criar a tabela NotasFiscais:
```text
aws dynamodb create-table --endpoint-url=http://localhost:4566 --table-name NotasFiscais \
--attribute-definitions AttributeName=id,AttributeType=S --key-schema AttributeName=id,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```
Verificar tabela: 
```text
aws dynamodb list-tables --endpoint-url=http://localhost:4566
```
* Download NoSQL Workbench for DynamoDB, para fazer querys ou outro a sua escolha: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/workbench.settingup.html

Script para gerar o arquivo notas_fiscais.json, na pasta codigo
Para executar: python gerar_dados.py - ira gerar um arquivo fake 


Enviar arquivo para S3:  
```text
aws s3 cp notas_fiscais.json s3://notas-fiscais-upload/notas_fiscais.json --endpoint-url=http://localhost:4566  
```

3. Lambda Function:  

```text
aws lambda create-function \  
--function-name ProcessarNotasFiscais \  
--runtime python3.9 \  
--role arn:aws:iam::000000000000:role/lambda-role \  
--handler grava_db.lambda_handler \  
--zip-file fileb://grava_db.zip \  
--endpoint-url=http://localhost:4566
```
  
Configurar o trigger S3:  
```text
aws lambda add-permission --function-name ProcessarNotasFiscais --statement-id s3-trigger --action \
"lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn arn:aws:s3:::notas-fiscais-upload \
--endpoint-url=http://localhost:4566  
```
   

Envie um arquivo JSON para o bucket S3:
```text  
aws s3 cp notas_fiscais.json s3://notas-fiscais-upload --endpoint-url=http://localhost:4566  
```
---

<br>
<br>

🧩 Documentação 
---
**LocalStack** 
https://www.localstack.cloud
































