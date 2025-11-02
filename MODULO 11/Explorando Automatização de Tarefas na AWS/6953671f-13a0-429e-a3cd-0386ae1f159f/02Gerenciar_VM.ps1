
$instanceId = "i-070f47ae1bf113be0"
$region = "sa-east-1"

Write-Host "O que você deseja fazer?"
Write-Host "1 - Ligar VM"
Write-Host "2 - Desligar VM"
Write-Host "3 - Verificar status da VM"
$choice = Read-Host "Escolha uma opção (1/2/3)"

if ($choice -eq 1) {
    Write-Host "Ligando a VM..."
    aws ec2 start-instances --instance-ids $instanceId --region $region
	aws rds start-db-instance --db-instance-identifier database-streaming
    Write-Host "A VM foi ligada com sucesso."
} elseif ($choice -eq 2) {
    Write-Host "Desligando a VM..."
    aws ec2 stop-instances --instance-ids $instanceId --region $region
	aws rds stop-db-instance --db-instance-identifier database-streaming
    Write-Host "A VM foi desligada com sucesso."
} elseif ($choice -eq 3) {
    Write-Host "Verificando o status da VM..."
    $status = aws ec2 describe-instances --instance-ids $instanceId --region $region --query 'Reservations[].Instances[].State.Name' --output text
    Write-Host "Status da VM: $status"
} else {
    Write-Host "Opção inválida. Por favor, escolha 1, 2 ou 3."
}
