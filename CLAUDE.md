# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HHIMS (Hospital Health Information Management System) is a PHP web application built on **CodeIgniter 2.x** for managing hospital operations including patient records, admissions, outpatient visits, laboratory, and pharmacy.

## Development Environment

- **Stack**: LAMP/XAMPP (Apache, MySQL, PHP)
- **Framework**: CodeIgniter 2.x with Modular Extensions (HMVC)
- **Database**: MySQL with UTF-8 encoding
- **Default URL**: http://127.0.0.1 or http://localhost
- **Default Login**: username `demo`, password `123`

### Database Setup

```bash
mysql -p
CREATE DATABASE hhims;
USE hhims;
SOURCE install/install.sql;
SOURCE install/data.sql;
```

Configure database credentials in `/application/config/database.php`.

## Architecture

### HMVC Pattern

The application uses **Modular Extensions (MX)** for HMVC architecture:

- **Core Extensions**: `/application/third_party/MX/` provides `MX_Controller`, `MX_Loader`, `MX_Router`
- **Custom Core**: `/application/core/` contains `MY_Loader`, `MY_Router` extending MX classes
- **Module Calls**: Use `Modules::run('module/controller/method', $params)` to invoke module controllers

### Module Structure

Feature modules in `/application/modules/`:
```
module_name/
├── controllers/
├── views/
└── index.html
```

Key modules: `patient`, `admission`, `opd`, `login`, `security`, `laboratory`, `pharmacy`, `clinic`, `report`, `form`, `table`, `lookup`

### Base Model Pattern

All models extend `My_Model` (`/application/core/My_Model.php`) which provides generic CRUD:

```php
class Mpatient extends My_Model {
    function __construct() {
        $this->_table = 'patient';
        $this->_key = 'PID';
    }
}
```

Models are prefixed with 'm' (e.g., `mpatient.php`, `madmission.php`).

### Access Control

Role-based permissions defined in `/application/config/hhims_access_config.php`:
- **User groups**: Programmer, Doctor, Admin, Nurse, LabTech, Pharm, Admission, Procedure_Room_Staff, Visitor
- **Permission levels**: `can_view`, `can_edit`, `can_create` per table/feature
- **Security check**: `Modules::run('security/check_edit_access', $table, 'permission')`

### Configuration Files

- `/application/config/database.php` - Database connection
- `/application/config/hhims_config.php` - Application settings (versions, colors, email, uploads)
- `/application/config/hhims_access_config.php` - RBAC definitions
- `/application/config/routes.php` - Default controller is `hhims`

### Dynamic Forms

Form definitions in `/application/forms/` define table structures and validation rules. The generic `Form` module controller uses these for CRUD operations.

## Key Conventions

- Controllers in modules extend `MX_Controller`
- Models use `$this->_table` and `$this->_key` for table mapping
- Session-based authentication with user data in `$_SESSION`
- Multi-mode support: Government Hospital (GH), Pain Clinic (PC), Private Practice (PP) via config
- Utility methods in `/application/libraries/mdscore.php`

## Important Notes

- Legacy codebase uses deprecated MySQL functions (e.g., `mysql_escape_string`)
- No automated test suite exists
- No build/CI pipeline - manual deployment expected
