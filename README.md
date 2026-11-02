# Centralized Backup and Recovery Server

## Project Overview
This project implements a centralized backup and recovery
system using Ubuntu Linux.

## My Role
Storage and Backup Administrator.

## Technologies Used
- Ubuntu Linux
- Bash scripting
- LVM
- ext4 filesystem
- SSH and SCP
- Cron
- GNU tar

## Main Features
1. Full backup
2. Incremental backup
3. Secure file transfer using SCP
4. Automated backup scheduling using Cron
5. Backup verification
6. Full backup restoration
7. Storage monitoring

## Scripts
- backup.sh – Performs full backups.
- incremental_backup.sh – Performs incremental backups.
- backup_menu.sh – Provides an interactive backup menu.
- client_backup.sh – Transfers client files to the server.

## Storage
Backup storage is mounted at /backup using LVM and ext4.

## Recovery
Full backup restoration is tested by extracting an archive
and verifying the restored files.
