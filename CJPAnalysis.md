# Analysis by Charles J. Palmer

Purpose: To ensure no adverse security threat from this module

## Need to do some further testing of the new SMTP module

### Existing SMTP function: Send-MailKitMessge

- Initial replacement found for Send-MailMessage
  - Works decent except when it doesn't
  - Deployed in numerous places that I will have to fix
  - Deployed as part of the initial SendGrid migration
- Send-MailKitMessage module/function has proven problematic on a number of occasions
  - Currently I can't run a script on my machine because it says there is already an assembly of the same name loaded..

### Proposed replacement: PoshMailKit/Send-MKMailMessage

 I found PoshMailKit (Send-MKMailMessage)
  It is a direct replacement for Send-MailMessage in that it accepts the same parameter names
  You can literally just change Send-MailMessage to Send-MKMailMessage and existing commands would work
  It seems to be a better wrapper for the MailKit than Send-MailKitMessage
  <https://www.poshcodebear.com/blog/2022/3/8/new-project-announcement-psmailkit>
  <https://github.com/poshcodebear/PoshMailKit>
  It is written in C# so it is a compiled module (much like Send-MailKitMessage)
  I did review the C# code on the above github and I didn't see anything sketchy on first review

## Parameter analysis

- Attachments (PSPath)
  - Modern and Legacy
  - String
  - Send-MailKitMessage: AttachmentList
- Bcc
  - Modern and Legacy
  - String
  - Send-MailKitMessage: BCCList
- Body
  - Modern and Legacy
  - String
  - Send-MailKitMessage: TextBody
- Cc
  - Modern and Legacy
  - String
  - Send-MailKitMessage: CCList
- Credential
  - Modern and Legacy
  - PSCredential
- From
  - Modern and Legacy
  - String
  - Send-MailKitMessage: From
- InlineAttachments
  - Modern and Legacy
  - Hashtable
- Port
  - Modern and Legacy
  - Int
  - Default is 25
  - Send-MailKitMessage: Port
- ReplyTo
  - Modern and Legacy
  - String
- SmtpServer
  - Modern and Legacy
  - String
  - Default will try to retrieve contents of PSEmailServer environment variable/
  - Send-MailKitMessage: SMTPServer
- Subject
  - Modern and Legacy
  - String
  - Send-MailKitMessage: Subject
- To
  - Modern and Legacy
  - String
  - Send-MailKitMessage: RecipientList
- BodyFormat
  - Modern
  - TextFormat - Apparently a class? Plain/Html/Text/Flowed/Enriched/CompressedRichText/RichText
  - Default is Plain
  - Send-MailKitMessage: HTMLBody
- CharsetEncoding
  - Modern
  - System.Text.Encoding - Apparently a class? UTF8/ASCII/BigEndianUnicode/utf-32BE/Unicode/UTF32
  - Default is UTF8
- ContentTransferEncoding
  - Modern
  - ContentEncoding - Apparently a class? Base64/QuotedPrintable/Binary/Default/EightBit/SevenBit/UUEncode
  - Default is Base64
- DeliveryStatusNotification
  - Modern
  - DeliveryStatusNotification - Apparently a class? Never/Success/Failure/Delay
  - Legacy counterpart: -DeliverNotificationOptions
- MessagePriority
  - Modern
  - MessagePriority - Apparently a class? Normal/NonUrgent/Urgent
  - Legacy counterpart -Priority
  - Default is Normal
- RequireSecureConnection
  - Modern
  - Switch
  - Legacy counterpart: -UseSsl
- SecureSocketOptions
  - Modern
  - SecureSocketOptions - Apparently a class? Auto/None/SslOnConnect/StartTls/StartTlsWhenAvailable
  - Legacy counterpart: -UseSsl
  - Default is Auto
  - Send-MailKitMessage: UseSecureConnectionIfAvailable corresponds with Auto I think
- Legacy
  - Legacy
  - Switch
  - If this switch is selected, following parameters are set:
    - SetLegacySsl
      - If useSsl, set to true else SecureSocketOptions.None
    - SetLegacyPriority
      - MessagePriority.Normal unless MailPriority is set to Low (NonUrgent) or High (Urgent)
    - SetLegacyEncoding
      - Sets ContentTransferEncoding to either Base64 or QuotedPrintable
    - SetLegacyNotification
      - Sets DeliverStatusNotification to DeliveryNotificationOption
    - SetLegacyBodyFormat
      - Sets BodyFormat to HTML if BodyAsHtml was specified
- BodyAsHtml (BAH)
  - Legacy
  - Switch
  - Modern counterpart: BodyFormat
- DeliveryNotificationOption (DNO)
  - Legacy
  - DeliveryNotificationOptions - Apparently a class? None/OnSuccess/OnFailure/Delay/Never
  - Modern counterpart: DeliveryStatusNotification
- Encoding (BE)
  - Legacy
  - Encoding - Apparently a class? ASCII/BigEndianUnicode/Default/Unicode/UTF8/UTF32
  - Modern counterpart: CharsetEncoding and ContentTransferEncoding
- Priority
  - Legacy
  - MailPriority
    - Low becomes MessagePriority.NonUrgent
    - High becomes MessagePriority.Urgent
    - Not specified becomes MessagePriority.Normal
  - Modern counterpart: MessagePriority
- UseSsl
  - Legacy
  - Switch
  - Modern counterpart: -SecureSocketOptions Auto -RequireSecureConnection
