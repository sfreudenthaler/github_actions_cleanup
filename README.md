# What even is github_actions_cleanup?
This shell script is intended to be a simple tool to quickly delete all GitHub 
Workflow runs for a given workflow.  It's initial impetus for existence was to 
cleanup the list of actions in [dotcms/core repo](https://github.com/dotCMS/core/actions/) 
where cruft had built up over time and made it difficult to find what you were 
looking for.  It uses the common tools of `GitHub CLI` and `jq` in combination 
with bash and a little user interactivity to accomplish it's task.  Note that 
this tool only removes the run history, it does not delete the code that defines 
the workflow or actions.

## Prerequisites and Setup
#### GitHub CLI
The tool assumes you've got a working (installed and authenticated) GitHub CLI.  
It uses the GitHub CLI for all interactions with GitHub, rather than use the 
GitHub API.  I made this choice because it simplifies authentication and secret 
handling for me.  Rather than read a sub-par quick-start that I could come up 
with, I'd suggest using [GitHubs own documentation](https://docs.github.com/en/github-cli/github-cli/quickstart).
#### jq
jq is super powerful and extremely common.  It gives us nice and easy ways to 
work with data in the JSON format.  It is supported in all sorts of languages 
and platforms, full documentation can be found at [the official site here](https://jqlang.github.io/jq/).  
In this case we just need the command line tool and it's easily installed using 
brew on macOS.  
```bash
brew install jq
```
#### Execution File Permission
Thankfully modern systems require users to explicitly set execution permissions 
on files downloaded from the internet.  Assuming you're in the directory where 
you've got your copy of [cleanup_workflow_runs.sh](https://github.com/sfreudenthaler/github_actions_cleanup/blob/main/cleanup_workflow_runs.sh) 
you can set the proper file permissions by running the following command.
```bash
sudo chmod +x ./cleanup_workflow_runs.sh
```
## Using The Tool
This tool takes only one parameter.  That's a GitHub workflow id.  The id can 
be the name, or the actual numeric id.  I suggest using the numeric id because 
it's required to be unique.  If you're using this tool, there's a decent chance 
you have a few workflow that share the same or very similar names.
#### Providing Workflow ID by argument
```bash
./cleanup_workflow_runs.sh --workflow your_workflow_id
```
#### Providing the Workflow ID by prompt
Alternately you can run the command without the `--workflow` flag.  In that case you'll be prompted for it during execution.
