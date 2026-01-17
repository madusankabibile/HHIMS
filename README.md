# HHIMS

Hospital Health Information Management System

## Installation Guide

### Requirements

- Apache Web Server
- MySQL / MariaDB
- PHP 7.4+ or PHP 8.x (with compatibility patches applied - see below)

### Quick Setup

#### Linux (LAMP)

1. Install LAMP on your PC
2. Clone this repository to `/var/www`
3. Set directory permissions: `sudo chmod 755 /var/www -R`
4. Configure database connection in `/var/www/application/config/database.php`
5. Create and populate the database (see Database Setup below)
6. Access via browser: `http://127.0.0.1`

#### Windows (XAMPP)

1. Install XAMPP
2. Clone this repository to `C:\xampp\htdocs` (or your htdocs directory)
3. Configure database connection in `application/config/database.php`
4. Create and populate the database (see Database Setup below)
5. Access via browser: `http://localhost`

### Database Configuration

Edit `application/config/database.php`:

```php
$db['default']['hostname'] = 'localhost';
$db['default']['username'] = 'your_username';
$db['default']['password'] = 'your_password';
$db['default']['database'] = 'hhims';
$db['default']['dbdriver'] = 'mysqli';  // Use 'mysqli' for PHP 7+
```

### Database Setup

```sql
mysql -u root -p
CREATE DATABASE hhims;
USE hhims;
SOURCE install/install.sql;
SOURCE install/data.sql;
```

### Default Login

- **Username:** demo
- **Password:** 123
- **Role:** Programmer (full privileges)

### Network Access

To run on a local area network, assign a fixed IP to the server machine and access it from other machines using that IP address in the browser.

---

## PHP 8 Compatibility

This codebase was originally developed for PHP 5.x. The following modifications have been applied to ensure compatibility with PHP 8.x:

### Core Framework Changes

| File | Change |
|------|--------|
| `index.php` | Added mysql_* compatibility layer (mysql_real_escape_string, mysql_fetch_field, mysql_fetch_array, mysql_num_fields, mysql_num_rows, mysql_connect, mysql_select_db, mysql_query, mysql_error, mysql_close, mysql_free_result) |
| `system/core/Common.php` | Fixed optional parameter order in log_message(), fixed return by reference issue |
| `system/core/Loader.php` | Fixed assignment by reference issue |
| `system/core/Output.php` | Added null check for str_replace() |
| `system/database/DB_driver.php` | Changed PHP 4 style constructor to __construct() |

### Application Changes

| File | Change |
|------|--------|
| `application/config/database.php` | Changed dbdriver from 'mysql' to 'mysqli' |
| `application/models/mpersistent.php` | Fixed optional parameter order in update(), create(), insert_batch() |
| `application/models/mappointment.php` | Fixed optional parameter order in get_next_token() |
| `application/modules/form/views/form_render.php` | Fixed optional parameters, null array access, and variable variable issues |
| `application/modules/lookup/controllers/lookup.php` | Fixed optional parameter order |
| `application/modules/admission/controllers/admission.php` | Fixed optional parameter order |
| `application/third_party/MX/Loader.php` | Added null coalescing for strtolower() |
| `application/libraries/class/MDSLicense.php` | Fixed SimpleXMLElement::getName() call |

### Development Mode

For debugging, set environment to 'development' in `index.php`:

```php
define('ENVIRONMENT', 'development');
```

For production, change back to 'production' to suppress error messages.

---

## Licensing

The repository includes a demonstration license. To display your hospital/practice name on reports, apply for a free license from hhims.org and copy the license file to the root directory.


