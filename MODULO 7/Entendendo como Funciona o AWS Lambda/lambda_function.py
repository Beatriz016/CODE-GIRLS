import json
import requests
 
def lambda_handler(event, context):
    
    url = 'https://viacep.com.br/ws/01001000/json/'
    resultado = requests.get(url, verify=False)
    
    numeros = json.loads(resultado.text)['ibge']
    
    return {
        'statusCode': 200,
        'body': json.dumps(numeros)
    }
