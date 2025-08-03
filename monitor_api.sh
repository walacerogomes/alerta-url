#!/bin/bash

URL_ALVO="https://www.google.com.br"
WEBHOOK_URL="https://discord.com/api/webhooks/1400912630645919805/05iR_24u5TubqGD5JyxGwtWaN6AFGoauRgNYpHJw-BbCyk5YDyjJEIE0cD3RVbGYZVe1"
LOG_FILE="/home/walace/Projetos/alertainfra/logs/api_monitor.log"

/usr/bin/mkdir -p "$(dirname "$LOG_FILE")"

CODIGO_RESPOSTA=$(/usr/bin/curl -s -o /dev/null -w "%{http_code}" "$URL_ALVO")

STATUS_MENSAGEM=""
ALERTA_MENSAGEM_DETALHADA_FORMATO=""

case "$CODIGO_RESPOSTA" in
  200)
    STATUS_MENSAGEM="SUCESSO"
    ;;
  000)
    STATUS_MENSAGEM="ERRO DE CONEXÃO/DNS"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CONEXÃO/DNS** : A URL %s não pôde ser alcançada. Código: **%s**."}'
    ;;
  3??)
    STATUS_MENSAGEM="REDIRECIONAMENTO (3xx)"
    ;;
  400)
    STATUS_MENSAGEM="ERRO DE CLIENTE (400 Bad Request)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (400 Bad Request)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  401)
    STATUS_MENSAGEM="ERRO DE CLIENTE (401 Unauthorized)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (401 Unauthorized)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  403)
    STATUS_MENSAGEM="ERRO DE CLIENTE (403 Forbidden)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (403 Forbidden)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  404)
    STATUS_MENSAGEM="ERRO DE CLIENTE (404 Not Found)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (404 Not Found)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  408)
    STATUS_MENSAGEM="ERRO DE CLIENTE (408 Request Timeout)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (408 Request Timeout)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  429)
    STATUS_MENSAGEM="ERRO DE CLIENTE (429 Too Many Requests)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (429 Too Many Requests)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  500)
    STATUS_MENSAGEM="ERRO DE SERVIDOR (500 Internal Server Error)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE SERVIDOR (500 Internal Server Error)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  502)
    STATUS_MENSAGEM="ERRO DE SERVIDOR (502 Bad Gateway)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE SERVIDOR (502 Bad Gateway)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  503)
    STATUS_MENSAGEM="ERRO DE SERVIDOR (503 Service Unavailable)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE SERVIDOR (503 Service Unavailable)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  504)
    STATUS_MENSAGEM="ERRO DE SERVIDOR (504 Gateway Timeout)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE SERVIDOR (504 Gateway Timeout)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  4??)
    STATUS_MENSAGEM="ERRO DE CLIENTE (4xx)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE CLIENTE (4xx)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  5??)
    STATUS_MENSAGEM="ERRO DE SERVIDOR (5xx)"
    ALERTA_MENSAGEM_DETALHADA_FORMATO='{"content": ":warning: **ALERTA: ERRO DE SERVIDOR (5xx)** : A URL %s retornou o código de erro **%s**."}'
    ;;
  *)
    STATUS_MENSAGEM="CÓDIGO INESPERADO"
    ;;
esac

/usr/bin/echo "[$(/usr/bin/date +"%Y-%m-%d %H:%M:%S")] $STATUS_MENSAGEM: $URL_ALVO... Código: $CODIGO_RESPOSTA" >> "$LOG_FILE"

/usr/bin/chmod 644 "$LOG_FILE"

if [ -n "$ALERTA_MENSAGEM_DETALHADA_FORMATO" ]; then
  /usr/bin/curl -H "Content-Type: application/json" -d @- "$WEBHOOK_URL" << EOF
$(printf "$ALERTA_MENSAGEM_DETALHADA_FORMATO" "$URL_ALVO" "$CODIGO_RESPOSTA")
EOF
fi
