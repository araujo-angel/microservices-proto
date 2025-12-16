#!/bin/bash

# Script para gerar código Go a partir dos arquivos .proto

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Gerando código Go para os microserviços...${NC}\n"

# Verifica se protoc está instalado
if ! command -v protoc &> /dev/null; then
    echo -e "${RED}Erro: protoc não está instalado.${NC}"
    echo "Instale o Protocol Buffer Compiler: https://grpc.io/docs/protoc-installation/"
    exit 1
fi

# Verifica se protoc-gen-go está instalado
if ! command -v protoc-gen-go &> /dev/null; then
    echo -e "${RED}Erro: protoc-gen-go não está instalado.${NC}"
    echo "Instale com: go install google.golang.org/protobuf/cmd/protoc-gen-go@latest"
    exit 1
fi

# Verifica se protoc-gen-go-grpc está instalado
if ! command -v protoc-gen-go-grpc &> /dev/null; then
    echo -e "${RED}Erro: protoc-gen-go-grpc não está instalado.${NC}"
    echo "Instale com: go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest"
    exit 1
fi

# Cria diretórios de output se não existirem
mkdir -p microservices-proto/golang/order
mkdir -p microservices-proto/golang/payment

# Gerar código Go para o serviço Order
echo -e "${YELLOW}Gerando código para o serviço Order...${NC}"
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    microservices-proto/order/order.proto

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Código Go gerado com sucesso para Order${NC}"
else
    echo -e "${RED}✗ Erro ao gerar código para Order${NC}"
    exit 1
fi

# Gerar código Go para o serviço Payment
echo -e "${YELLOW}Gerando código para o serviço Payment...${NC}"
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    microservices-proto/payment/payment.proto

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Código Go gerado com sucesso para Payment${NC}"
else
    echo -e "${RED}✗ Erro ao gerar código para Payment${NC}"
    exit 1
fi

echo -e "\n${GREEN}Todos os arquivos foram gerados com sucesso!${NC}"
echo -e "${YELLOW}Arquivos gerados:${NC}"
echo "  - microservices-proto/golang/order/"
echo "  - microservices-proto/golang/payment/"
