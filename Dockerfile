# Build the app using the .NET 7.0 SDK
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy the solution file and project file(s)
COPY FeedCord.sln ./
COPY FeedCord/*.csproj ./FeedCord/

# Restore dependencies for the project
RUN dotnet restore

# Copy the rest of the source code and build the app
COPY . ./
WORKDIR /app/FeedCord
RUN dotnet publish -c Release -o /app/out

# Create the runtime image
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app

# Copy the compiled app from the build stage
COPY --from=build-env /app/out .

# Copy the restart script into the container
COPY restart-first-run.sh /app

# Make the script executable
RUN chmod +x /app/restart-first-run.sh

# Set the entry point to your application
ENTRYPOINT ["/app/restart-first-run.sh"]
