#!/bin/bash
set -euo pipefail

# Wait for DVWA to be accessible 
until curl -s --head "http://target:80/setup.php" | grep -q "200 OK"; do
    echo "Waiting for DVWA to be ready..."
    sleep 5
done

# Run DVWA setup
curl -s -X POST "http://target:80/setup.php" \
    -d "create_db=Create+%2F+Reset+Database" \
    -H "Content-Type: application/x-www-form-urlencoded"

echo "DVWA database setup completed"