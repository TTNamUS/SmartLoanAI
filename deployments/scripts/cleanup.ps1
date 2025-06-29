# Cleanup SmartLoan AI Kubernetes deployment

Write-Host "🧹 Cleaning up SmartLoan AI deployment..." -ForegroundColor Yellow

$NAMESPACE = "smartloan-ai"

# Check if namespace exists
$namespaceExists = kubectl get namespace $NAMESPACE --ignore-not-found 2>$null
if ($namespaceExists) {
    Write-Host "🗑️ Deleting namespace and all resources..." -ForegroundColor Red
    kubectl delete namespace $NAMESPACE
    
    Write-Host "⏳ Waiting for namespace to be deleted..." -ForegroundColor Yellow
    kubectl wait --for=delete namespace/$NAMESPACE --timeout=120s
    
    Write-Host "✅ SmartLoan AI deployment cleaned up successfully!" -ForegroundColor Green
} else {
    Write-Host "ℹ️ SmartLoan AI deployment not found" -ForegroundColor Blue
}

# Optional: Clean up persistent volumes (uncomment if needed)
# Write-Host "🗑️ Cleaning up persistent volumes..." -ForegroundColor Red
# kubectl delete pv mariadb-pv qdrant-pv valkey-pv --ignore-not-found

Write-Host ""
Write-Host "🔍 Remaining resources:" -ForegroundColor Cyan
kubectl get all -A | Select-String "smartloan" | ForEach-Object { $_.Line }
