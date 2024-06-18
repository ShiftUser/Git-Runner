# Stage 1: Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2019 AS build
WORKDIR /src

# Copy and restore project dependencies
COPY ["src/SeleniumDocker.csproj", "src/"]
RUN dotnet restore "src/SeleniumDocker.csproj"

# Copy the source code and build the application
COPY src/ src/
ARG configuration=Release
RUN dotnet build "SeleniumDocker.csproj" -c $configuration -o /app/build

# Publish the application
RUN dotnet publish "SeleniumDocker.csproj" -c $configuration -p:UseAppHost=false -o /app/publish

# Stage 2: Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0-windowsservercore-ltsc2019 AS final
WORKDIR /app

# Set PowerShell as the default shell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Download and install Google Chrome, ChromeDriver, Shift Browser, and Windows Application Driver
ADD https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.61/win64/chrome-win64.zip C:/chrome/
ADD https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.61/win64/chromedriver-win64.zip C:/drivers/
ADD https://github.com/microsoft/WinAppDriver/releases/download/v1.2.1/WindowsApplicationDriver_1.2.1.msi C:/winappdriver/

RUN Expand-Archive -Path 'C:/chrome/chrome-win64.zip' -DestinationPath 'C:/chrome/'
RUN Expand-Archive -Path 'C:/drivers/chromedriver-win64.zip' -DestinationPath 'C:/drivers/'
RUN Move-Item -Path 'C:/drivers/chromedriver-win64/chromedriver.exe' -Destination 'C:/drivers/chromedriver.exe'

# Install WinAppDriver
RUN Start-Process msiexec.exe -ArgumentList '/i', 'C:/winappdriver/WindowsApplicationDriver_1.2.1.msi', '/quiet', '/norestart' -NoNewWindow -Wait

# Set PATH environment variable to include Chrome and ChromeDriver
RUN setx /M PATH "$($env:PATH);C:\drivers;C:\chrome"

# Enable Developer Mode
RUN powershell -Command "& { \
    Set-ExecutionPolicy Unrestricted -Scope Process -Force; \
    New-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock\" -Force; \
    Set-ItemProperty -Path \"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock\" -Name \"AllowDevelopmentWithoutDevLicense\" -Value 1; \
    Set-ItemProperty -Path \"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock\" -Name \"AllowAllTrustedApps\" -Value 1; \
}"

# Install TightVNC for remote access
RUN choco install tightvnc -y

# Set up VNC server configuration
RUN powershell -Command "New-Item -ItemType Directory -Force -Path C:/Users/ContainerAdministrator/AppData/Local/TightVNC"
RUN powershell -Command "Set-Content -Path 'C:/Users/ContainerAdministrator/AppData/Local/TightVNC/vncpasswd.txt' -Value 'password'"

# Set environment variables
ENV RUNNING_IN_DOCKER=true

# Expose ports for VNC and WinAppDriver
EXPOSE 5900 4723

# Copy the published application
COPY --from=build /app/publish .

# Copy the entrypoint script
COPY ./entrypoint.ps1 /app/entrypoint.ps1

# Set the entry point to start VNC server, WinAppDriver, and your application
ENTRYPOINT ["powershell.exe", "-File", "entrypoint.ps1"]
