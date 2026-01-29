#!/bin/bash
#
# HHIMS Database Setup Script
# Run this script after MySQL is installed and running
#

set -e

# Configuration - Update these as needed
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="hhims"
DB_USER="root"
DB_PASS=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}   HHIMS Database Setup Script${NC}"
echo -e "${GREEN}======================================${NC}"
echo

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}Error: MySQL client is not installed.${NC}"
    echo "Please install MySQL first:"
    echo "  sudo apt-get update && sudo apt-get install -y mysql-server mysql-client"
    exit 1
fi

# Check if MySQL is running
if ! mysqladmin ping -h"$DB_HOST" --silent 2>/dev/null; then
    echo -e "${RED}Error: MySQL server is not running.${NC}"
    echo "Please start MySQL:"
    echo "  sudo service mysql start"
    exit 1
fi

echo -e "${GREEN}MySQL is running.${NC}"

# Prompt for database credentials
read -p "MySQL username [$DB_USER]: " input_user
DB_USER=${input_user:-$DB_USER}

read -sp "MySQL password: " input_pass
echo
DB_PASS=${input_pass:-$DB_PASS}

read -p "Database name [$DB_NAME]: " input_db
DB_NAME=${input_db:-$DB_NAME}

# Create database
echo
echo -e "${YELLOW}Creating database '$DB_NAME'...${NC}"
mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Database created successfully.${NC}"
else
    echo -e "${RED}Failed to create database. Check your credentials.${NC}"
    exit 1
fi

# Import schema
echo -e "${YELLOW}Importing database schema...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SCRIPT_DIR/install/new/install.sql"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Schema imported successfully.${NC}"
else
    echo -e "${RED}Failed to import schema.${NC}"
    exit 1
fi

# Import sample data
read -p "Import sample data? (y/n) [y]: " import_data
import_data=${import_data:-y}

if [[ "$import_data" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Importing sample data (this may take a few minutes)...${NC}"
    mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SCRIPT_DIR/install/new/data.sql"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Sample data imported successfully.${NC}"
    else
        echo -e "${RED}Failed to import sample data.${NC}"
        exit 1
    fi
fi

# Update database configuration
echo -e "${YELLOW}Updating application configuration...${NC}"
CONFIG_FILE="$SCRIPT_DIR/application/config/database.php"

if [ -f "$CONFIG_FILE" ]; then
    # Backup original
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup"

    # Update configuration
    sed -i "s/\$db\['default'\]\['hostname'\] = .*/\$db['default']['hostname'] = '$DB_HOST:$DB_PORT';/" "$CONFIG_FILE"
    sed -i "s/\$db\['default'\]\['username'\] = .*/\$db['default']['username'] = '$DB_USER';/" "$CONFIG_FILE"
    sed -i "s/\$db\['default'\]\['password'\] = .*/\$db['default']['password'] = '$DB_PASS';/" "$CONFIG_FILE"
    sed -i "s/\$db\['default'\]\['database'\] = .*/\$db['default']['database'] = '$DB_NAME';/" "$CONFIG_FILE"

    echo -e "${GREEN}Configuration updated.${NC}"
else
    echo -e "${RED}Warning: Could not find database.php${NC}"
fi

echo
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}   Setup Complete!${NC}"
echo -e "${GREEN}======================================${NC}"
echo
echo "You can now access HHIMS:"
echo "  1. Start the PHP development server:"
echo "     cd $SCRIPT_DIR && php -S localhost:8080"
echo "  2. Open in browser: http://localhost:8080"
echo "  3. Login with: demo / 123"
echo
echo "For production, configure Apache or Nginx."
