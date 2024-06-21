# install-dependencies.ps1

Write-Output "Installing NuGet packages..."

dotnet add $env:Test_Project_Path package Appium.WebDriver --version 5.0.0
dotnet add $env:Test_Project_Path package Selenium.WebDriver --version 4.21.0
dotnet add $env:Test_Project_Path package Coverlet.Collector --version 3.0.3
dotnet add $env:Test_Project_Path package ExtentReports.Core --version 1.0.2
dotnet add $env:Test_Project_Path package FluentAssertions --version 6.2.0
dotnet add $env:Test_Project_Path package Microsoft.Extensions.Configuration.EnvironmentVariables --version 8.0.0
dotnet add $env:Test_Project_Path package Microsoft.Extensions.Configuration.Json --version 8.0.0
dotnet add $env:Test_Project_Path package Microsoft.NET.Test.Sdk --version 17.0.0
dotnet add $env:Test_Project_Path package NUnit --version 3.13.2
dotnet add $env:Test_Project_Path package NUnit.Analyzers --version 3.2.0
dotnet add $env:Test_Project_Path package NUnit3TestAdapter --version 4.0.0
dotnet add $env:Test_Project_Path package Selenium.Support --version 4.21.0

Write-Output "NuGet packages installation completed."


