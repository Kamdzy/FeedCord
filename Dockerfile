# Build the app using the .NET 7.0 SDK
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application files and build the app
COPY . ./
RUN dotnet publish -c Release -o out

# Create the runtime image
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app

# Copy the compiled app from the build stage
COPY --from=build-env /app/out .

# Set the entry point to your application
ENTRYPOINT ["dotnet", "FeedCord.dll"]
