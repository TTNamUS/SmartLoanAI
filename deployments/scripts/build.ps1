# Build Docker Images for SmartLoan AI

Write-Host "🏗️ Building Docker images..." -ForegroundColor Green

# Configuration
$REGISTRY = "localhost:5000"  # Change to your registry
$PROJECT = "smartloan-ai"
$VERSION = "latest"

# Change to project root
Set-Location (Split-Path (Split-Path $MyInvocation.MyCommand.Path))

# Function to build and push image
function Build-And-Push {
    param($context, $dockerfile, $imageName)
    
    Write-Host "🔨 Building $imageName..." -ForegroundColor Yellow
    
    $fullImageName = "$REGISTRY/$PROJECT/$imageName`:$VERSION"
    
    # Build image
    docker build -t $fullImageName -f $dockerfile $context
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Built $fullImageName successfully" -ForegroundColor Green
        
        # Push image (optional)
        if ($REGISTRY -ne "localhost:5000") {
            Write-Host "📤 Pushing $fullImageName..." -ForegroundColor Yellow
            docker push $fullImageName
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Pushed $fullImageName successfully" -ForegroundColor Green
            } else {
                Write-Host "❌ Failed to push $fullImageName" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "❌ Failed to build $fullImageName" -ForegroundColor Red
    }
}

# Build images
Build-And-Push "backend" "backend/Dockerfile" "backend"
Build-And-Push "chatbot-ui" "chatbot-ui/Dockerfile" "chatbot-ui"

Write-Host ""
Write-Host "📋 Built images:" -ForegroundColor Cyan
Write-Host "- $REGISTRY/$PROJECT/backend:$VERSION"
Write-Host "- $REGISTRY/$PROJECT/chatbot-ui:$VERSION"

Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update image names in K8s manifests if using different registry"
Write-Host "2. Run: .\scripts\deploy.ps1"
