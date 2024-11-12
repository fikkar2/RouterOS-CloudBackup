# MikroTik Cloud Backup Script with Error Logging

:local backupPassword "PasswordHere"
:local result
:local backupTime
:local backupDate
:local oldBackupDate
:local newBackupDate

# Check if there is a current Cloud Backup file
:if ([:len [/system/backup/cloud find]] > 0) do={
    :set oldBackupDate [/system/backup/cloud get [find] date]
} else={
    :set oldBackupDate "None"
}

# Check if a previous backup exists
:if ($oldBackupDate = "None") do={
    # Create a new backup if none exists
    :set result [/system/backup/cloud/upload-file action=create-and-upload password=$backupPassword]
        :set backupTime [/system/clock get time]
        :set backupDate [/system/clock get date]
} else={
    # Attempt to replace the existing backup
    :do {
        :set result [/system/backup/cloud/upload-file action=create-and-upload replace=[find] password=$backupPassword]
        :set backupTime [/system/clock get time]
        :set backupDate [/system/clock get date]
    } on-error={
        :log error "Cloud backup failed: $result"
    }
}
delay 1s
# Check if backup was successful
:set newBackupDate [/system/backup/cloud get [find] date]
:if ( $newBackupDate!=$oldBackupDate) do={
    :log info "Cloud backup successful."
    :log info "Backup created on $backupDate at $backupTime"
} else={
    :log error "Cloud backup encountered an issue: $result"
}