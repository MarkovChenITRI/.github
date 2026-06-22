<#
.SYNOPSIS
    建立 AI Hub WebUI 所需的 Azure Key Vault 與 Azure SQL Database，並把機密與資源名稱寫入 Key Vault。

.DESCRIPTION
    對應 docs/azure_resources_preparation.md 的 Step 1、Step 3、Step 4：
    建立 Resource Group、Key Vault、Azure SQL Database（SQL 邏輯伺服器 + database），
    並把以下 7 個 secret 寫入 Key Vault：
        SECRET-KEY、AZURE-SQLSERVER-PASSWORD、AZURE-SQLSERVER-USER、
        SQLSERVER-SERVER-NAME、SQLSERVER-DATABASE、
        AZURE-APP-SERVICE-NAME（可選）、APP-SERVICE-URL（可選）

    執行前請先以 `az login` 完成登入，並用 `az account set --subscription <id>`
    確認目前 subscription 為目標 subscription。

    本腳本是 idempotent 的：Resource Group / Key Vault / SQL 邏輯伺服器若已存在會直接沿用，
    只會補建尚不存在的 database（若需調整管理密碼，請改用 Azure Portal 或
    `az sql server update` 調整既有伺服器）。

.PARAMETER ResourceGroup
    資源群組名稱。

.PARAMETER Location
    Azure region，預設 southeastasia。

.PARAMETER KeyVaultName
    Key Vault 名稱。

.PARAMETER SqlServerName
    SQL 邏輯伺服器名稱。

.PARAMETER SqlDatabaseName
    Azure SQL Database 名稱，預設 ai_hub。

.PARAMETER SqlAdminUser
    SQL 邏輯伺服器管理者帳號，預設 aihubadmin。

.PARAMETER SqlAdminPassword
    SQL 邏輯伺服器管理者密碼。未提供時會自動產生並只在終端輸出一次。

.PARAMETER AppServiceName
    App Service 名稱（可選）。提供時會寫入 Key Vault secret AZURE-APP-SERVICE-NAME。

.PARAMETER AppServiceUrl
    App Service 對外 URL（可選）。提供時會寫入 Key Vault secret APP-SERVICE-URL。

.EXAMPLE
    ./provision-azure-resources.ps1 `
        -ResourceGroup "ai-hub-webui" `
        -KeyVaultName "ai-hub-secret-key" `
        -SqlServerName "ai-hub-database"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroup,

    [string]$Location = "southeastasia",

    [Parameter(Mandatory = $true)]
    [string]$KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string]$SqlServerName,

    [string]$SqlDatabaseName = "ai_hub",

    [string]$SqlAdminUser = "aihubadmin",

    [string]$SqlAdminPassword,

    [string]$AppServiceName,

    [string]$AppServiceUrl
)

$ErrorActionPreference = "Stop"

function New-RandomSecret {
    param([int]$Length = 32)
    -join ((48..57) + (65..90) + (97..122) | Get-Random -Count $Length | ForEach-Object { [char]$_ })
}

Write-Host "==> 建立（或沿用）Resource Group：$ResourceGroup（$Location）"
az group create --name $ResourceGroup --location $Location --output none

Write-Host "==> 檢查 Key Vault：$KeyVaultName"
$kvExists = az keyvault show --name $KeyVaultName --resource-group $ResourceGroup --query "name" --output tsv 2>$null
if (-not $kvExists) {
    Write-Host "    Key Vault 不存在，建立新的 Key Vault。"
    az keyvault create --name $KeyVaultName --resource-group $ResourceGroup --location $Location --output none
}
else {
    Write-Host "    Key Vault 已存在，沿用現有資源。"
}

if (-not $SqlAdminPassword) {
    $SqlAdminPassword = New-RandomSecret -Length 32
    Write-Host "==> 未提供 SQL 邏輯伺服器管理密碼，已自動產生（僅顯示一次，請自行保存）："
    Write-Host "    $SqlAdminPassword"
}

$secretKey = New-RandomSecret -Length 48
Write-Host "==> 已自動產生 Flask SECRET_KEY（僅顯示一次，請自行保存）："
Write-Host "    $secretKey"

Write-Host "==> 檢查 SQL 邏輯伺服器：$SqlServerName"
$sqlServerExists = az sql server show --resource-group $ResourceGroup --name $SqlServerName --query "name" --output tsv 2>$null
if (-not $sqlServerExists) {
    Write-Host "    SQL 邏輯伺服器不存在，建立新的伺服器（允許 Azure 服務連線）。"
    az sql server create `
        --resource-group $ResourceGroup `
        --name $SqlServerName `
        --location $Location `
        --admin-user $SqlAdminUser `
        --admin-password $SqlAdminPassword `
        --output none
    az sql server firewall-rule create `
        --resource-group $ResourceGroup `
        --server $SqlServerName `
        --name AllowAzureServices `
        --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 `
        --output none
}
else {
    Write-Host "    SQL 邏輯伺服器已存在，沿用現有資源。若需調整管理密碼，請改用 Azure Portal 或 az sql server 指令。"
}

Write-Host "==> 檢查 database：$SqlDatabaseName"
$sqlDbExists = az sql db show --resource-group $ResourceGroup --server $SqlServerName --name $SqlDatabaseName --query "name" --output tsv 2>$null
if (-not $sqlDbExists) {
    Write-Host "    database 不存在，建立新的 Azure SQL Database（Basic 規格）。"
    az sql db create --resource-group $ResourceGroup --server $SqlServerName --name $SqlDatabaseName --edition Basic --output none
}
else {
    Write-Host "    database 已存在，跳過建立。"
}

Write-Host "==> 寫入 Key Vault secrets"
az keyvault secret set --vault-name $KeyVaultName --name "SECRET-KEY" --value $secretKey --output none
az keyvault secret set --vault-name $KeyVaultName --name "AZURE-SQLSERVER-PASSWORD" --value $SqlAdminPassword --output none
az keyvault secret set --vault-name $KeyVaultName --name "AZURE-SQLSERVER-USER" --value $SqlAdminUser --output none
az keyvault secret set --vault-name $KeyVaultName --name "SQLSERVER-SERVER-NAME" --value $SqlServerName --output none
az keyvault secret set --vault-name $KeyVaultName --name "SQLSERVER-DATABASE" --value $SqlDatabaseName --output none

if ($AppServiceName) {
    az keyvault secret set --vault-name $KeyVaultName --name "AZURE-APP-SERVICE-NAME" --value $AppServiceName --output none
}
if ($AppServiceUrl) {
    az keyvault secret set --vault-name $KeyVaultName --name "APP-SERVICE-URL" --value $AppServiceUrl --output none
}

Write-Host ""
Write-Host "==> 完成。請到 GitHub repo 的 Settings > Secrets and variables > Actions > Variables 設定下列三個值："
Write-Host "    AZURE_RESOURCE_GROUP = $ResourceGroup"
Write-Host "    AZURE_KEY_VAULT_NAME = $KeyVaultName"
Write-Host "    AZURE_REGION         = $Location"

if (-not $AppServiceName -or -not $AppServiceUrl) {
    Write-Host ""
    Write-Host "提醒：尚未提供 -AppServiceName / -AppServiceUrl，AZURE-APP-SERVICE-NAME 與 APP-SERVICE-URL 兩個 secret 尚未寫入 Key Vault。"
    Write-Host "      建立 App Service 後，請重新執行本腳本並補上這兩個參數，或自行以 az keyvault secret set 補上。"
}
