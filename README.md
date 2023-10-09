# dep_user_config
Script to run after a user logs into a Mac to install apps and run scripts using Jamf triggers


Enter your own icon/title/etc in the variables section

Setup to use Jamf triggers to install apps and run scripts

If using with less than 15 apps/scripts, need to delete corresponding entries from:

• App Common Name
• Path to check if app is already installed
• Jamf Custom Trigger
• Icon Path
• Installing Text
• Success Text
• Installing Apps

To verify scripts have run, I put this command at the end of the script if successful, then use it to verify within this script.
touch "/Library/Application Support/JAMF/Receipts/package.pkg"

Swiftdialog parts based on https://gist.github.com/smithjw/b61a180b099624cebf61a8460fc594ed

Original script "flow" by @nstrauss
