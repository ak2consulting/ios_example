//
//  SYViewController.m
//  Singly API Example
//
//  Written by Justin Mecham <justin@mecham.net>
//  Copyright (c) 2012 Singly, Inc. All rights reserved.
//

#import "GTMHTTPFetcherLogging.h"
#import "GTMOAuth2ViewControllerTouch.h"

#import "SYViewController.h"
#import "SYWebViewController.h"

static NSString *const kKeychainItemName = nil;
static NSString *const kMyClientID = @"XXXXXXXXXXXXXXXXXXXXXXXXXX";
static NSString *const kMyClientSecret = @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

@interface SYViewController ()

- (GTMOAuth2Authentication *)singlyAuth;

@end

@implementation SYViewController

@synthesize token;

#pragma mark - View Callbacks

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Customize the table view background
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
  self.tableView.backgroundView = imageView;

  // Override the back bar button item label
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:nil
                                                                          action:nil];
  
  // Enable logging on the Google HTTP Fetcher
  [GTMHTTPFetcher setLoggingEnabled:YES];
}

- (void)viewDidUnload
{
  [self setTableView:nil];
  [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];

  if (selectedPath.section == 1) // API Endpoints
  {
    SYWebViewController *webViewController = segue.destinationViewController;
    NSString *endpoint;

    // Determine the endpoint URL that we wish to send the user to.
    switch (selectedPath.row)
    {
      case 0: // View Profiles
        endpoint = @"https://carealot.singly.com/profiles";
        break;
      default:
        break;
    }

    webViewController.endpoint = endpoint;
    webViewController.token = self.token;
  }
}

#pragma mark - Table View Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  // We only want to handle the Connected Services section with this delegate,
  // as we will use segues for the other sections (see prepareForSegue:sender:
  // above). Return unless the user has selected a row from the Connected
  // Services section.
  if (indexPath.section != 0) return;
  
  switch (indexPath.row)
  {
    case 0: // Facebook
      [self authorizeWithFacebook];
      break;
    case 1: // Twitter
      [self authorizeWithTwitter];
      break;
    default:
      break;
  }
  
}

#pragma mark - OAuth Support

- (GTMOAuth2Authentication *)singlyAuth
{

  // Set the token URL to the Singly token endpoint.
  NSURL *tokenURL = [NSURL URLWithString:@"https://carealot.singly.com/oauth/access_token"];

  // Set a bogus redirect URI. It won't actually be used as the redirect will
  // be intercepted by the OAuth library and handled in the app.
  NSString *redirectURI = @"http://www.singly.com/OAuthCallback";
  
  GTMOAuth2Authentication *auth;
  auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Singly Developer API"
                                                           tokenURL:tokenURL
                                                        redirectURI:redirectURI
                                                           clientID:kMyClientID
                                                       clientSecret:kMyClientSecret];

  // The Singly API does not return a token type, therefore we set one here to
  // avoid a warning being thrown.
  [auth setTokenType:@"Bearer"];

  return auth;
}

- (void)authorizeWithFacebook
{
  return [self authorize:@"facebook"];
}

- (void)authorizeWithTwitter
{
  return [self authorize:@"twitter"];
}

- (void)authorize:(NSString *)service
{
//  [self signOut];

  GTMOAuth2Authentication *auth = [self singlyAuth];

  // Prepare the Authorization URL. We will pass in the name of the service
  // that we wish to authorize with.
  NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://carealot.singly.com/oauth/authorize?service=%@", service]];
  
  // Display the authentication view
  GTMOAuth2ViewControllerTouch *viewController;
  viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                               authorizationURL:authURL
                                                               keychainItemName:kKeychainItemName
                                                                       delegate:self
                                                               finishedSelector:@selector(viewController:finishedWithAuth:error:)];
  [viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://carealot.singly.com/"]];
  
  // Now push our sign-in view
  [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    NSLog(@"viewController:finishedWithAuth:error: FAILED");
    // Authentication failed
  } else {
    NSLog(@"viewController:finishedWithAuth:error: SUCCEEDED, %@", auth);
    self.token = auth.accessToken;
    // Authentication succeeded
  }
}

- (void)authentication:(GTMOAuth2Authentication *)auth
               request:(NSMutableURLRequest *)request
     finishedWithError:(NSError *)error {
  if (error != nil) {
    NSLog(@"authentication:request:finishedWithError: FAILED");
    // Authorization failed
  } else {
    NSLog(@"authentication:request:finishedWithError: SUCCEEDED");
    // Authorization succeeded
  }
}

@end
