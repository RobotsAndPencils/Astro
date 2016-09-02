# Administration

This page contains information to help the maintainers of the project keep it up to date on CocoaPods.

## Deploy a new release to CocoaPods

A Rakefile is included in the repo to help with automating this process.

## Using the Rakefile

Once you've got the rake dependencies setup, you can publish a release by running a command from the project root directory:

```
rake release[1.1.1]
```
(where 1.1.1 would be the next version number to be released)

If all was successful, it should have:

* Updated Astro's podspec with the new version number provided
* Create a new commit to the Astro repository and tag that commit with the new version number provided
* Push a new version of Astro's podspec to CocoaPods

## Rakefile Dependencies

Before you push updates with the Rakefile you'll need to install some dependencies and a bit of configuration...

### Installing xcpretty

xcpretty is required as it is used to format the logs during xcodebuild. Installation is as follows:

```
gem install xcpretty
```

### Installing octokit and netrc gems

The included Rakefile utilizes octokit and netrc to interact with the Github API. Installation is as follows:

```
gem install octokit
gem install netrc
```

### Setting up netrc authentication

The netrc gem allows for authenticating with octokit while externalizing your github credentials outside the project. You are able to create personal tokens on Github (which act the same as oauth tokens). Setup is as follows:

1. Go to your Github personal access token settings: https://github.com/settings/tokens
2. Create a new token with the `repo` scope (this should also check off `repo:status`, `repo_deployment`, and `public_repo`)
3. Copy that personal token (eg. `J1qK1c18UUGJFAzz9xnH56584l4`) for later (NOTE: once you navigate away from this page, this token will be hidden and cannot be recovered)
4. Create a new file on your machine at path, `~/.netrc`
5. The contents for this file should be like so:
   
   ```
   machine api.github.com    
     login your-github-username
     password J1qK1c18UUGJFAzz9xnH56584l4
   ```
   
   (Where the password is the token you generated in step 2. More information about using a netrc file can be found on [octokit's readme](https://github.com/octokit/octokit.rb#using-a-netrc-file))
6. Change the permissions of `~/.netrc` to 0600 (can do so by running `chmod 600 ~/.netrc` on the command line)

That's it! You should be good to go...

## Cookbook of manual steps (in case you don't want to use the Rakefile)

- update the version # in Astro.podspec
- update the version # in Astro/Info.plist (or via xcode project view)
- run `pod install` (to ensure all the local podfiles get update)
- run `pod lib lint Astro.podspec` (to make sure there aren't any errors)
- push that code back up to your release branch in github
- after reviewing/merging back into master then you’ll need to create/tag the release
- run `pod repo push Astro.podspec`
