**Q**: What is this?
----------------

**A**: A script to trigger a build in TFS for a git repo at the HEAD
   revision if it doesn't already exist

**Q**: Why? Doesn't TFS have a "trigger on checkin" option?
-------------------------------------------------------

**A**: Yes it does. And yet, it fails to work reliably for me. When
   I get over fighting, I just hack a way. Also, this was practice
   for all the PS I'm having to write lately.

**Q**: How do I use it?
-------------------

**A**: Check out config.ps1. Modify as appropriate. Run the script.
   I suggest creating a Scheduled Task to run every minute.

**Q**: The user name and password are in the config file, in plain text!
--------------------------------------------------------------------

**A**: Sorry, questions must be in the form of a question.

**Q**: Fine, WHY are the user name and password stored in the config in plain text?
-------------------------------------------------------------------

**A**: Because the TFS server I'm dealing with doesn't seem to like 
  access tokens that I generate at said server. Every request I
  make with an access token fails. As if the hosting web server
  doesn't allow basic authentication. But I have no control over
  that. So plaintext it is. Keep this in a safe(-ish) place.

**Q**: Licensing?
-------------

**A**: BSD, 3-clause. Basically, you can modify it, use it, distribute it,
    but you may not claim it as entirely your own. Attribute! Or don't.
    I won't really follow up and if you weren't going to attribute,
    you probably don't have a conscience anyway.
    Basically, you can do whatever you like with the code, but I
    accept no liability whatsoever for what this script does, 
    including, but not limited to:
* eating your cat
* stealing your girlfriend
* catapulting the earth out of orbit

Basically, if it breaks, you can keep both parts.

**Q**: What's the batch file for?
---------------------------------

**A**: Because I'm too lazy to:
* cd to the folder where this lives
* type `powershell -f autobuild.ps1`
* cd back again