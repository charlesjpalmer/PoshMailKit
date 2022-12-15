#requires -Modules PoshMailKit
#From the examples
#Import-Module -Name PoshMailKit
#Ex1 - Doesn't work because PSEmailServer doesn't return a value
Send-MKMailMessage -From 'Charles <cjp@weareflood.com>' -To 'Paul <paul.regan@weareflood.com>' -Subject 'Test Email'
$sendMKMailMessageSplat = @{
    From = 'Charles <cjp@weareflood.com>'
    To = 'Charles <cjp@weareflood.com>'
    Subject = 'Test Email'
    SmtpServer = 'smarthost.weareflood.com'
}

Send-MKMailMessage @sendMKMailMessageSplat

$sgCreds = Get-SendGridCredFromHash
$sendMKMailMessageSplat = @{
    From = 'Charles <cjp@weareflood.com>'
    To = 'Charles <cjp@weareflood.com>'
    Subject = 'Test Email'
    SmtpServer = 'smtp.sendgrid.net'
    Credential = $sgCreds
}

Send-MKMailMessage @sendMKMailMessageSplat

#Ex2 - Shows multiple recipients and how to add an attachment. Also shows multiple recipient and Message Priority
$sendMKMailMessageSplat = @{
    From = 'Charles <cjp@weareflood.com>'
    To = 'Charles <cjp@weareflood.com>', 'Paul <paul.regan@weareflood.com>'
    Subject = 'Test Email with Attachment'
    SmtpServer = 'smtp.sendgrid.net'
    Credential = $sgCreds
    Attachments = '.\CJPAnalysis.md'
    Body = "My analysis of the C# code"
    MessagePriority = 'Urgent'
    DeliveryStatusNotification = 'Success'
}

Send-MKMailMessage @sendMKMailMessageSplat

#Ex3 Using credentials (which I already figured out) and TLS
$sendMKMailMessageSplat = @{
    From = 'Charles <cjp@weareflood.com>'
    To = 'Charles <cjp@weareflood.com>', 'Paul <paul.regan@weareflood.com>'
    Cc = 'cjpalmer@gmail.com'
    Subject = "Forcing TLS"
    SmtpServer = 'smtp.sendgrid.net'
    Credential = $sgCreds
    SecureSocketOptions = 'StartTls'
}

Send-MKMailMessage @sendMKMailMessageSplat

<#
By default, Send-MKMailMessage will send the email using security if available. You can force specific security with SecureSocketOptions parameter
A review of the C# code (both 1.1.1 [main] and 2.0.0 [dev]) doesn't show anything suspect so I think we are good to go using this module.
Time to start swapping out all instances of Send-MailKitMessage with Send-MKMailMessage
#>
