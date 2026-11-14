# ETAPA 1: COMPILACIÓN #
FROM golang:alpine AS build
WORKDIR /app

# COPIAR GO.MOD PARA APROVECHAR CACHÉ DE CAPAS #
COPY go.mod ./
RUN go mod download

# RESTO DEL CÓDIGO Y COMPLIAR BINARIO ESTÁTICO #
COPY . .
RUN CGO_ENABLED=0 go build -o servidor

# ETAPA 2: IMAGEN FINAL #
FROM alpine:latest
WORKDIR /app

# LO NECESARIO PARA EJECUTAR: BINARIO, PLANTILLAS E IMÁGENES #
COPY --from=build /app/servidor .
COPY templates ./templates
COPY static ./static

EXPOSE 8080
CMD ["./servidor"]