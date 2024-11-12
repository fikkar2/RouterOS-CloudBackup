# MikroTik Cloud Backup Script with Error Logging

:local backupPassword "PasswordHere"
:local result
:local backupTime

# Attempt to replace existing backup
:do {
    :set result [/system/backup/cloud/upload-file action=create-and-upload replace=[/system backup cloud find 0] password=$backupPassword]
:set backupTime [/system/clock/get date]
} on-error={
    :log error "Cloud backup failed: $result"
}

# Check if backup was successful
:if ($result = "done") do={
    :log info "Cloud backup successful."
} else={
    :log error "$backupTime Cloud backup encountered an issue: $result"
}