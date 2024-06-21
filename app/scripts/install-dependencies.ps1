# install-dependencies.ps1

Write-Output "Installing NuGet packages..."

dotnet add $env:Test_Project_Path package Appium.WebDriver
dotnet add $env:Test_Project_Path package Coverlet.Collector
dotnet add $env:Test_Project_Path package ExtentReports.Core
dotnet add $env:Test_Project_Path package FluentAssertions
dotnet add $env:Test_Project_Path package Microsoft.Extensions.Configuration.EnvironmentVariables
dotnet add $env:Test_Project_Path package Microsoft.Extensions.Configuration.Json
dotnet add $env:Test_Project_Path package Microsoft.NET.Test.Sdk
dotnet add $env:Test_Project_Path package NUnit
dotnet add $env:Test_Project_Path package NUnit.Analyzers
dotnet add $env:Test_Project_Path package NUnit3TestAdapter

Write-Output "NuGet packages installation completed."
