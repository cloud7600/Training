# Deployment script for Azure Bicep templates (PowerShell)

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment = "dev",
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId
)

# Error handling
$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Azure Bicep Deployment Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Environment:     $Environment"
Write-Host "Resource Group:  $ResourceGroupName"
Write-Host "Location:        $Location"
Write-Host "=========================================" -ForegroundColor Cyan

try {
    # Set subscription if provided
    if ($SubscriptionId) {
        Write-Host "Setting subscription to: $SubscriptionId" -ForegroundColor Yellow
        Set-AzContext -SubscriptionId $SubscriptionId
    }

    # Create resource group if it doesn't exist
    Write-Host "Ensuring resource group exists..." -ForegroundColor Yellow
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if (-not $rg) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Host "Resource group created." -ForegroundColor Green
    } else {
        Write-Host "Resource group already exists." -ForegroundColor Green
    }

    # Deploy the Bicep template
    Write-Host "Starting deployment..." -ForegroundColor Yellow
    $templateFile = Join-Path $PSScriptRoot "..\deployments\main.bicep"
    $parametersFile = Join-Path $PSScriptRoot "..\parameters\$Environment\main.parameters.json"

    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $templateFile `
        -TemplateParameterFile $parametersFile `
        -Verbose

    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "Deployment completed successfully!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Cyan
    
    # Output results
    Write-Host "Deployment Outputs:" -ForegroundColor Yellow
    $deployment.Outputs | Format-Table -AutoSize

} catch {
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host "Deployment failed!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Red
    exit 1
}
