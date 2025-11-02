# # Desafio Modulo 01

A atividade proposta foi criar uma arquitetura que utilizava EC2 com EBS ou S3 com Lambda. 

## Transação e Notificação de Pagamento

![alt text](<./images/Desafio 01.png>)

---

## ⚙️ Descrição da Arquitetura 
 - O usuario faz o pagamento através do app do banco
 - Os dados do pagamento a ser feito passam para um API Gateway que faz a validação basica do arquivo com esses dados
 - Em seguida o Api Gateway faz um trigger para a Lambda que validada os dados que estão nesse arquivo e envia uma requisição de pagamento para API Externa, que processa a transação de pagamento e assim retorna um arquivo gerado um recibo com os dados do pagamento 
 - Então a Lambda envia esse arquivo para um Bucket S3, com isso o S3 envia um event Trigger do arquivo armazenado para uma outra Lambda que faz a leitura do objeto que esta no S3 e publica a mensagem para o SNS
 - O SNS finaliza o prcesso passando a notificação do pagamento para o app do banco.


## 🧩 Melhorias
A mais processos que podem ser adicionados, como:
- DynamoDB para armazenar o historico de transações e status de pagamento
- Um back-end que recebe o evento do SNS e envia para o aplicativo do usuario
- Adiconar CloudWatch para alertas relacionados falhas, pagamentos pendentes ou erros de Lambda.
- Adicionar metricas para tempo de processamento







