<div align="center">

# 🏥 HHIMS
### Hospital Health Information Management System

*A comprehensive, open-source web platform for managing hospital operations*

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![PHP](https://img.shields.io/badge/PHP-7.4%2B%20%7C%208.x-777BB4?logo=php&logoColor=white)](https://php.net)
[![CodeIgniter](https://img.shields.io/badge/CodeIgniter-2.0.3-EF4223?logo=codeigniter&logoColor=white)](https://codeigniter.com)
[![MySQL](https://img.shields.io/badge/MySQL-5.7%2B-4479A1?logo=mysql&logoColor=white)](https://mysql.com)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [System Requirements](#-system-requirements)
- [Installation](#-installation)
  - [Linux / LAMP](#linux--lamp)
  - [Windows / WampServer or XAMPP](#windows--wampserver-or-xampp)
- [Database Setup](#-database-setup)
- [Configuration](#-configuration)
- [Default Login](#-default-login)
- [User Roles & Permissions](#-user-roles--permissions)
- [Modules](#-modules)
- [Patient Flow](#-patient-flow)
- [URL Structure](#-url-structure)
- [Operation Modes](#-operation-modes)
- [PHP 8 Compatibility](#-php-8-compatibility)
- [Project Structure](#-project-structure)
- [License](#-license)
- [Credits](#-credits)

---

## 🌐 Overview

**HHIMS** (Hospital Health Information Management System) is a full-featured, open-source hospital management platform originally developed by the **Information and Communication Technology Agency of Sri Lanka (ICTA)**. It provides end-to-end management of healthcare facility operations — from patient registration and outpatient consultations through to inpatient admissions, laboratory tests, and pharmacy dispensing.

The system is designed for use in **government hospitals**, **pain clinics**, and **private practices**, and supports multi-role, role-based access control with a flexible modular architecture.

---

## ✨ Features

| Category | Capabilities |
|---|---|
| **Patient Management** | Registration, Hospital Identification Number (HIN) with Luhn checksum, patient search, allergy tracking |
| **Outpatient Department** | Visit recording, clinical notes, prescriptions, OPD history |
| **Admissions** | Inpatient admissions, ward assignment, bed management, discharge |
| **Laboratory** | Test ordering, result entry, lab order tracking |
| **Pharmacy** | Prescription dispensing, drug stock management, low-stock alerts |
| **Appointments** | Appointment scheduling, token system, queue management |
| **Clinic** | Specialist clinic management |
| **Procedure Room** | Procedure recording and management |
| **Reporting** | IMMR (Indoor Morbidity and Mortality Returns), configurable reports |
| **User Management** | Role-based access control, user groups, audit trails |
| **Notifications** | In-system notifications, email support via SMTP |
| **Attachments** | File and image attachment to patient records |
| **Diagrams** | Anatomical diagram annotation |

---

## 🛠 Technology Stack

| Layer | Technology |
|---|---|
| **Backend** | PHP 7.4+ / PHP 8.x |
| **Framework** | CodeIgniter 2.0.3 (HMVC via Modular Extensions) |
| **Database** | MySQL 5.7+ / MariaDB with InnoDB engine |
| **Frontend** | jQuery 1.5, jQuery UI, Bootstrap, Angular.js |
| **PDF Generation** | FPDF library |
| **Email** | PHPMailer |
| **Charts** | JS-Charts |
| **Architecture** | HMVC (Hierarchical Model–View–Controller) |

---

## 💻 System Requirements

- **Web Server:** Apache 2.4+
- **PHP:** 7.4 or 8.x (PHP 8 compatibility patches included — see [PHP 8 Compatibility](#-php-8-compatibility))
- **Database:** MySQL 5.7+ or MariaDB 10.3+
- **PHP Extensions:** `mysqli`, `mbstring`, `xml`, `json`, `session`
- **Browser:** Chrome (recommended), Firefox, Edge

---

## 🚀 Installation

### Linux / LAMP

```bash
# 1. Install a LAMP stack (Ubuntu/Debian example)
sudo apt update && sudo apt install apache2 mysql-server php php-mysqli php-mbstring php-xml

# 2. Clone the repository
cd /var/www
sudo git clone https://github.com/your-org/hhims.git
sudo chmod 755 /var/www/hhims -R

# 3. Configure Apache virtual host (or use the default /var/www/html)
# Point your DocumentRoot to /var/www/hhims

# 4. Set write permissions for logs and attachments
sudo chmod 775 /var/www/hhims/application/logs
sudo chmod 775 /var/www/hhims/attach
```

### Windows / WampServer or XAMPP

1. Install [WampServer](https://www.wampserver.com/) or [XAMPP](https://www.apachefriends.org/)
2. Clone or copy this repository to your web root:
   - WampServer: `C:\wamp64\www\hhims\`
   - XAMPP: `C:\xampp\htdocs\hhims\`
3. Start Apache and MySQL services
4. Proceed to [Database Setup](#-database-setup) below
5. Access via browser: `http://localhost/hhims`

---

## 🗄 Database Setup

### 1. Configure the connection

Edit `application/config/database.php`:

```php
$db['default']['hostname'] = 'localhost';
$db['default']['username'] = 'your_username';
$db['default']['password'] = 'your_password';
$db['default']['database'] = 'hhims';
$db['default']['dbdriver'] = 'mysqli';   // Required for PHP 7+
$db['default']['char_set'] = 'utf8';
$db['default']['dbcollat']  = 'utf8_general_ci';
```

### 2. Create the database and import schema

**Option A — MySQL CLI:**

```bash
mysql -u root -p
```

```sql
CREATE DATABASE hhims CHARACTER SET utf8 COLLATE utf8_general_ci;
USE hhims;
SOURCE /path/to/hhims/install/new/install.sql;
SOURCE /path/to/hhims/install/new/data.sql;
```

**Option B — phpMyAdmin:**

1. Create a new database named `hhims` with `utf8_general_ci` collation
2. Import `install/new/install.sql` (schema — ~2,400 lines)
3. Import `install/new/data.sql` (sample data — ~168,000 lines)

> **Note:** `data.sql` is large. If phpMyAdmin times out, increase `max_execution_time` in `php.ini` or use the CLI method.

### 3. Database update scripts

For upgrading an existing installation, migration scripts are located in `install/update/changes.sql`.

---

## ⚙️ Configuration

Key application settings are in `application/config/hhims_config.php`:

```php
// Operation mode: GH = Government Hospital | PC = Pain Clinic | PP = Private Practice
$config["purpose"] = "GH";

// Application branding
$config["title"]    = "HHIMS V2.1";
$config["app_name"] = "HHIMS";

// Session auto-logout (seconds)
$config["auto_logout_time"] = 300;

// Drug stock alert threshold
$config["drug_alert_count"] = 10;

// SMTP email settings (for notifications)
$config['mail_smtp_host'] = 'smtp.example.com';
$config['mail_smtp_port'] = 587;
$config['mail_smtp_user'] = 'user@example.com';
$config['mail_smtp_pass'] = 'password';
```

### Environment

Set the environment in `index.php`:

```php
// Use 'development' to show errors; 'production' to suppress them
define('ENVIRONMENT', 'production');
```

---

## 🔐 Default Login

| Field | Value |
|---|---|
| **URL** | `http://localhost/hhims` (or `http://localhost/hhims/index.php/login`) |
| **Username** | `demo` |
| **Password** | `123` |
| **Role** | Programmer (full privileges) |

> **Security Notice:** Change the default password immediately after first login in a production environment.

---

## 👥 User Roles & Permissions

HHIMS uses role-based access control. Each role has fine-grained `can_view`, `can_edit`, and `can_create` permissions per module.

| Role | Description |
|---|---|
| **Programmer** | Full system access — all modules, configuration, user management |
| **Doctor** | OPD, admissions, clinic, prescriptions, lab orders |
| **Admin** | Administrative access; in PP mode can edit/delete pre-production records |
| **Nurse** | Patient care, ward management, vital signs |
| **LabTech** | Laboratory order processing and result entry |
| **Pharm** | Pharmacy dispensing and drug stock management |
| **Admission** | Patient registration and admission management |
| **Procedure_Room_Staff** | Procedure room operations |
| **Visitor** | Read-only access |

Permissions are configured in `application/config/hhims_access_config.php`.

---

## 📦 Modules

The application is built around 34 independent HMVC modules:

| Module | Path | Description |
|---|---|---|
| `patient` | `modules/patient` | Patient registration, search, HIN generation |
| `opd` | `modules/opd` | Outpatient visits, prescriptions, clinical notes |
| `admission` | `modules/admission` | Inpatient admissions, discharge, bed management |
| `laboratory` | `modules/laboratory` | Lab test orders and results |
| `pharmacy` | `modules/pharmacy` | Drug dispensing |
| `drug_stock` | `modules/drug_stock` | Drug inventory management |
| `appointment` | `modules/appointment` | Appointment scheduling and tokens |
| `clinic` | `modules/clinic` | Specialist clinic management |
| `ward` | `modules/ward` | Ward and bed configuration |
| `procedureroom` | `modules/procedureroom` | Procedure room records |
| `report` | `modules/report` | IMMR and other reports |
| `user` | `modules/user` | User account management |
| `hospital` | `modules/hospital` | Hospital/facility configuration |
| `registry` | `modules/registry` | Disease and condition registry |
| `notification` | `modules/notification` | In-system notifications |
| `chat` | `modules/chat` | Internal messaging |
| `attach` | `modules/attach` | File attachments |
| `diagram` | `modules/diagram` | Anatomical diagram annotation |
| `search` | `modules/search` | Global patient/record search |
| `security` | `modules/security` | Authentication and access control |
| `lookup` | `modules/lookup` | Reference data lookups |
| `form` | `modules/form` | Generic dynamic form engine |
| `table` | `modules/table` | Generic data grid engine |
| `report` | `modules/report` | Reporting engine |
| `preference` | `modules/preference` | User/system preferences |
| `question` | `modules/question` | Clinical questionnaires |
| `questionnaire` | `modules/questionnaire` | Questionnaire management |
| `menu` | `modules/menu` | Navigation menu builder |
| `help` | `modules/help` | In-system help |

---

## 🔄 Patient Flow

```
┌─────────────────┐
│  Patient Arrives │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     New patient?
│  Patient Search  │ ──────────────────► Register Patient
└────────┬────────┘                      (generates HIN)
         │ Found
         ▼
┌─────────────────┐
│   OPD Visit      │  ── Consultation, Prescription, Lab Orders
└────────┬────────┘
         │ If admission needed
         ▼
┌─────────────────┐
│  Admission       │  ── Ward, Bed, Daily Notes
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌────────┐ ┌────────┐
│   Lab   │ │Pharmacy│
└────────┘ └────────┘
         │
         ▼
┌─────────────────┐
│    Discharge     │
└─────────────────┘
```

---

## 🌐 URL Structure

URLs follow the CodeIgniter convention:

```
http://host/index.php/{module}/{controller}/{method}/{param}
```

| Action | URL |
|---|---|
| Login | `index.php/login` |
| New patient | `index.php/patient/create` |
| View patient | `index.php/patient/view/{PID}` |
| OPD visits | `index.php/opd/visits/{PID}` |
| New admission | `index.php/admission/create/{PID}` |
| Lab orders | `index.php/laboratory/orders/{PID}` |
| Drug stock | `index.php/drug_stock` |
| Reports | `index.php/report` |
| User management | `index.php/user` |

---

## 🏥 Operation Modes

HHIMS supports three operation modes, configured via `$config["purpose"]` in `hhims_config.php`:

| Mode | Key | Description |
|---|---|---|
| **Government Hospital** | `GH` | Full hospital management with wards, admissions, IMMR reporting |
| **Pain Clinic** | `PC` | Clinic-focused workflows with specialist features |
| **Private Practice** | `PP` | Private practice with billing-oriented flows; includes pre-production edit/delete |

---

## 🔧 PHP 8 Compatibility

HHIMS was originally written for PHP 5.x. This repository includes patches for full PHP 7.4 and PHP 8.x compatibility.

### Framework Patches (`system/`)

| File | Fix Applied |
|---|---|
| `system/core/Controller.php` | Added `#[\AllowDynamicProperties]` to `CI_Controller` |
| `system/core/Model.php` | Added `#[\AllowDynamicProperties]` to `CI_Model` |
| `system/core/Common.php` | Fixed optional parameter order; fixed return-by-reference |
| `system/core/Loader.php` | Fixed assignment-by-reference; `CI_Loader` dynamic property support |
| `system/core/Output.php` | Added null check for `str_replace()` |
| `system/core/Input.php` | PHP 8 compatibility updates |
| `system/core/Router.php` | PHP 8 compatibility updates |
| `system/core/URI.php` | PHP 8 compatibility updates |
| `system/database/DB_driver.php` | PHP 4 constructor → `__construct()`; `#[\AllowDynamicProperties]` on `CI_DB_driver` |

### Application Patches (`application/`)

| File | Fix Applied |
|---|---|
| `index.php` | `mysql_*` compatibility shim (all removed functions re-implemented via `mysqli`) |
| `application/config/database.php` | Driver changed from `mysql` → `mysqli` |
| `application/third_party/MX/Controller.php` | `#[\AllowDynamicProperties]` on `MX_Controller` |
| `application/third_party/MX/Loader.php` | `#[\AllowDynamicProperties]` on `MX_Loader`; null-coalescing fixes |
| `application/libraries/class/MDSLicense.php` | `#[\AllowDynamicProperties]`; fixed `SimpleXMLElement::getName()` |
| `application/models/mpersistent.php` | Fixed optional parameter ordering |
| `application/models/mappointment.php` | Fixed optional parameter ordering |
| `application/modules/form/views/form_render.php` | Fixed null array access and variable-variable usage |
| `application/modules/lookup/controllers/lookup.php` | Fixed optional parameter ordering |
| `application/modules/admission/controllers/admission.php` | Fixed optional parameter ordering |

---

## 📁 Project Structure

```
hhims/
├── application/
│   ├── config/                  # App configuration files
│   │   ├── database.php         # DB credentials (do not commit)
│   │   ├── hhims_config.php     # Core HHIMS settings
│   │   ├── hhims_access_config.php  # RBAC definitions
│   │   └── routes.php           # URL routing
│   ├── core/                    # Framework extensions
│   │   ├── My_Model.php         # Base model with CRUD helpers
│   │   ├── MY_Loader.php        # Extends MX_Loader
│   │   └── MY_Router.php        # Extends MX_Router
│   ├── modules/                 # 34 HMVC feature modules
│   │   ├── patient/
│   │   ├── opd/
│   │   ├── admission/
│   │   └── ...
│   ├── models/                  # Shared data models
│   ├── views/                   # Base/shared view templates
│   ├── forms/                   # Dynamic form definitions (65+ forms)
│   ├── libraries/               # Custom libraries
│   │   ├── mdscore.php          # Core MDS utility library
│   │   └── class/               # MDSIMMR, MDSReporter, MDSUpload, etc.
│   └── third_party/MX/          # HMVC Modular Extensions
├── system/                      # CodeIgniter 2.0.3 framework
├── install/
│   ├── new/
│   │   ├── install.sql          # Full database schema
│   │   └── data.sql             # Sample / seed data
│   └── update/
│       └── changes.sql          # Incremental migration scripts
├── js/                          # JavaScript libraries (jQuery, Bootstrap, etc.)
├── css/                         # Stylesheets
├── images/                      # Static image assets
├── attach/                      # Patient file attachments (excluded from git)
├── logs/                        # Application logs (excluded from git)
├── index.php                    # Front controller + PHP 8 mysql_* shim
└── mdsfoss.key                  # License key (do not commit)
```

---

## 📄 License

This project is licensed under the **GNU Affero General Public License v3.0**.

> This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

See [LICENSE](https://www.gnu.org/licenses/agpl-3.0.html) for the full text.

### Application License Key

The system includes a demonstration license key. To display your hospital or practice name on reports, apply for a free license at [hhims.org](http://www.hhims.org) and place the `.key` file in the project root directory.

> **Important:** Never commit `mdsfoss.key` or `application/config/database.php` with production credentials to version control.

---

## 👏 Credits

| Role | Name | Contact |
|---|---|---|
| **Primary Author** | Mr. Thurairajasingam Senthilruban | TSRuban@mdsfoss.org |
| **Medical Consultant** | Dr. Denham Pole | DrPole@gmail.com |
| **Private Practice Module** | Laura Lucas | ICT Agency of Sri Lanka |
| **Programme Manager** | Shriyananda Rathnayake | ICT Agency of Sri Lanka |
| **Supervisors** | Jayanath Liyanage, Erandi Hettiarachchi | ICT Agency of Sri Lanka |

**Developed by:** [Information and Communication Technology Agency of Sri Lanka (ICTA)](http://www.icta.lk)

**Project website:** [www.hhims.org](http://www.hhims.org)

---

<div align="center">

*HHIMS — Improving healthcare through open-source technology*

</div>
