#!/bin/bash
set -e

# deploy.sh — example from Chapter 08
echo "Deploying Flask App..."

cd /home/ubuntu/myapp
git pull origin main

sudo systemctl restart flaskapp
echo "Deployment complete!"
