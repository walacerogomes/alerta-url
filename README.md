# Monitoramento de Disponibilidade de API com Bash e Discord

Este é um script Bash para monitorar a disponibilidade de uma URL, registrar o status em logs e enviar alertas detalhados para o Discord em caso de problemas.

---

## Funcionalidades e Pré-requisitos

### Funcionalidades
* **Verificação de Status HTTP:** Checa o código de resposta da URL alvo.
* **Detecção de Erros:** Identifica falhas de conexão (`000`), erros de cliente (`4xx`) e erros de servidor (`5xx`).
* **Alertas no Discord:** Envia notificações detalhadas para um webhook do Discord para erros críticos, com códigos em negrito.
* **Registro de Logs:** Mantém um histórico de todas as verificações (sucesso, redirecionamento, erro).
* **Execução Automática:** Projetado para rodar via `cron` em segundo plano.

### Pré-requisitos
* Sistema operacional Linux.
* `curl` instalado.
* Acesso a um terminal com permissões para criar arquivos e agendar tarefas no `crontab` do seu usuário.
* Uma **URL de Webhook do Discord** para os alertas.

---

## Configuração Completa

Siga estes passos para configurar seu monitoramento.

### 1. Crie a Estrutura do Projeto e o Script

Primeiro, crie a pasta base do seu projeto e a subpasta para os logs. Em seguida, baixe o arquivo do script `monitor_api.sh` e jogue dentro da pasta principal.

```bash
mkdir /home/seu_usuario/pasta
mkdir /home/seu_usuario/pasta/logs
```

### 2. Conceda Permissão de Execução ao Script

```bash
chmod +x /home/seu_usuario/pasta/monitor_api.sh
```

### 3. Configure o Contrab

```bash
crontab -e
```
Adicione a seguinte linha ao final do arquivo `crontab` e salve

```
*/5 * * * * /bin/bash /home/seu_usuario/pasta/monitor_api.sh >> /home/seu_usuario/pasta/logs/cron_output.log 2>&1
```

Isso fara que o alerta seja enviado a cada 5 minutos para o discord e aos logs. Caso queira mudar só alterar o 5 por a quantidade de minutos que deseja.
