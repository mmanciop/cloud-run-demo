FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Add internal feed (temporary)
RUN dotnet nuget add source https://instananugetserver.azurewebsites.net/nuget/ --name instana

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime imaged
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

ENV DOTNET_STARTUP_HOOKS="/app/Instana.Tracing.Core.dll"
ENV CORECLR_ENABLE_PROFILING=1
ENV CORECLR_PROFILER="{cf0d821e-299b-5307-a3d8-b283c03916dd}"
ENV CORECLR_PROFILER_PATH="/app/instana_tracing/CoreProfiler.so"

ENV GCP_PROJECT demo
ENV PUBSUB_TOPIC demo
ENV PUBSUB_SUBSCRIPTION demo

WORKDIR /app
COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "dotnet-gcs.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet dotnet-gcs.dll
