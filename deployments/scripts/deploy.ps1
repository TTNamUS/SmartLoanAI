# SmartLoan AI - Organized Kubernetes Deployment

Write-Host "🚀 SmartLoan AI - Organized Deployment..." -ForegroundColor Green

# Configuration
$NAMESPACE = "smartloan-ai"

# Check prerequisites
Write-Host "✅ Checking prerequisites..." -ForegroundColor Yellow

try {
    kubectl version --client | Out-Null
    kubectl cluster-info | Out-Null
    Write-Host "✅ Kubernetes ready" -ForegroundColor Green
} catch {
    Write-Host "❌ Kubernetes not available" -ForegroundColor Red
    exit 1
}

# Change to k8s directory
Set-Location (Split-Path $MyInvocation.MyCommand.Path | Split-Path)

# Function to apply directory
function Apply-Directory {
    param($directory, $description)
    
    if (Test-Path $directory) {
        Write-Host "📁 Deploying $description..." -ForegroundColor Blue
        
        Get-ChildItem "$directory\*.yaml" | ForEach-Object {
            Write-Host "   📄 Applying $($_.Name)..." -ForegroundColor Yellow
            kubectl apply -f $_.FullName
        }
        
        Write-Host "✅ $description deployed" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Directory $directory not found" -ForegroundColor Yellow
    }
}

# Deploy in order
Apply-Directory "infrastructure" "Infrastructure (Namespace, Config, Volumes, Autoscaling, Network Policies)"

# Wait for namespace
Write-Host "⏳ Waiting for namespace..." -ForegroundColor Yellow
kubectl wait --for=condition=Ready namespace/$NAMESPACE --timeout=60s

Apply-Directory "databases" "Databases (MariaDB, Valkey, Qdrant)"

# Wait for databases
Write-Host "⏳ Waiting for databases..." -ForegroundColor Yellow
Start-Sleep 10
kubectl wait --for=condition=Ready pod -l component=database -n $NAMESPACE --timeout=300s
kubectl wait --for=condition=Ready pod -l component=cache -n $NAMESPACE --timeout=300s
kubectl wait --for=condition=Ready pod -l component=vectordb -n $NAMESPACE --timeout=300s

Apply-Directory "backend" "Backend (API, Workers)"

# Wait for backend
Write-Host "⏳ Waiting for backend..." -ForegroundColor Yellow
kubectl wait --for=condition=Ready pod -l component=backend -n $NAMESPACE --timeout=300s

Apply-Directory "frontend" "Frontend (Chatbot UI)"

# Wait for frontend
Write-Host "⏳ Waiting for frontend..." -ForegroundColor Yellow
kubectl wait --for=condition=Ready pod -l component=frontend -n $NAMESPACE --timeout=300s

Write-Host "✅ SmartLoan AI deployed successfully!" -ForegroundColor Green

# Show status
Write-Host ""
Write-Host "📊 Deployment Status:" -ForegroundColor Cyan
kubectl get all -n $NAMESPACE

Write-Host ""
Write-Host "🌐 Access URLs:" -ForegroundColor Cyan
Write-Host "Chatbot UI: http://chatbot.smartloan.local"
Write-Host "API: http://api.smartloan.local"

Write-Host ""
Write-Host "🔧 Port Forward Commands:" -ForegroundColor Cyan
Write-Host "kubectl port-forward svc/chatbot-ui-service 8051:8051 -n $NAMESPACE"
Write-Host "kubectl port-forward svc/idp-api-service 8081:8081 -n $NAMESPACE"

Write-Host ""
Write-Host "📝 Add to hosts file:" -ForegroundColor Cyan
Write-Host "127.0.0.1 chatbot.smartloan.local"
Write-Host "127.0.0.1 api.smartloan.local"
