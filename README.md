# Singly API Example

This app is a simple example of how you might integrate with the
Singly Developer API from an iOS application using the Google OAuth2
library. As such, it is a very simple app and not intended to show
best practices of application structure or design.

## How to Use

You will need an OAuth Client ID and Client Secret from Singly in order
to use the API.

Once you have your Client ID and Client Secret, open the file
SYViewController.m and replace the values defined at the top of the file
with your Client ID and Client Secret:

    static NSString *const kMyClientID = @"[your client id]";
    static NSString *const kMyClientSecret = @"[your client secret]";

## Persistence

There is presently a crashing issue when using the keychain support in
the Google OAuth2 library. I'm not quite sure why this is happening, so
keychain persistence is currently disabled in this example.

This means that your OAuth token will not persist between app launches.
You will need to re-auth each time you launch the example in order for
any of the API Endpoints to succeed.

I am still looking into why this is happening. Feel free to poke and prod
and send a pull request if you figure out why.
