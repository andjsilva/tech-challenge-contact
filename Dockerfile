# Etapa base para a imagem de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
ENV ASPNETCORE_ENVIRONMENT=Development

RUN echo "AMBIENTE: ${ASPNETCORE_ENVIRONMENT}"

USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copia os arquivos de projeto e restaura as dependências
COPY ["WebApi/WebApi.csproj", "WebApi/"]
COPY ["WebApiTest/WebApiTest.csproj", "WebApiTest/"]
RUN dotnet restore "WebApi/WebApi.csproj"
RUN dotnet restore "WebApiTest/WebApiTest.csproj"

# Copia o restante dos arquivos
COPY . .

# Compila a aplicação
WORKDIR "/src/WebApi"
RUN dotnet build "WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Compila os testes
WORKDIR "/src/WebApiTest"
RUN dotnet build "WebApiTest.csproj" -c $BUILD_CONFIGURATION -o /app/test-build

# Executa os testes e garante que os logs são exibidos
WORKDIR "/src/WebApiTest"
RUN dotnet test "WebApiTest.csproj" -c $BUILD_CONFIGURATION --verbosity normal --logger "console;verbosity=detailed" || exit 1

# Etapa de publicação
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
WORKDIR "/src/WebApi"
RUN dotnet publish "WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Etapa final para a imagem de runtime
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApi.dll"] 
