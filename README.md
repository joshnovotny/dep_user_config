# dep_user_config
Script to run after a user logs into a Mac to install apps and run scripts using Jamf triggers

<img width="500" alt="Screenshot 2023-12-05 at 12 55 11 PM" src="https://github.com/joshnovotny/dep_user_config/assets/100789888/d6812a99-d4cc-4454-9256-e8a02843f2a1">

<img width="500" alt="Screenshot 2023-12-05 at 12 55 49 PM" src="https://github.com/joshnovotny/dep_user_config/assets/100789888/123a849a-b1e0-4d4c-9809-f1d92cbc0765">

<img width="500" alt="Screenshot 2023-08-07 at 12 24 36 PM (1)" src="https://github.com/joshnovotny/dep_user_config/assets/100789888/e41085ee-a0a2-458d-842b-96ad33aaa7ae">

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

To verify scripts have run, I put this command at the end of my scripts if successful, then use it to verify within this script.
touch "/Library/Application Support/JAMF/Receipts/package.pkg"

Swiftdialog parts based on https://gist.github.com/smithjw/b61a180b099624cebf61a8460fc594ed

Original script "flow" by @nstrauss
