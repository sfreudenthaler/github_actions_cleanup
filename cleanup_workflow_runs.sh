#!/bin/bash

# Name: Cleanup Workflow Runs
# Author: "Steve Freudenthaler <https://github.com/sfreudenthaler>"

# This shell script is intended to quickly delete all GitHub Workflow runs 
# for a given workflow.  It's initial impetus for existance was to cleanup 
# the list of actions on [dotcms/core](https://github.com/dotCMS/core/actions/)

#TODO: Option to disable workflow when all runs are cleaned up

# Define usage helper function 
usage() {
    echo "Usage: $0 -w <workflowID> -r <OWNER/REPO>"
    exit 1
}

# Get workflow ID we want to cleanup by command arg OR if not provided, by prompt
if [ $# -eq 0 ]; then
    read -p "Which workflow (Name or ID) do you want to delete all runs? " workflowID
    read -p "Provide target <OWNER/REPO> to cleanup. " targetRepo  
else
    while getopts ":w:r:" opt; do
        case $opt in
            w) workflowID=$OPTARG ;;
            r) targetRepo=$OPTARG ;;
            \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
            :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
        esac
    done
    shift
fi

echo "You provided Workflow ID: $workflowID"

# Get the list of run id's for the provided workflow
runIDs=( $(gh api --paginate -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/dotcms/core/actions/workflows/$workflowID/runs | jq '.workflow_runs[].id') ) 

# provide list of runIDs for the workflow 
echo "The following is a list of GitHub Workflow Run IDs that will be deleted..." 
for id in "${runIDs[@]}"; do
    echo "$id"
done
echo -e "\nTotal:" ${#runIDs[@]} "\n"

# Prompt the user for confirmation before deleting
# TODO: add a "quiet" mode that doesn't require interactivity 
read -p "Are you sure you want to continue? (yes/no): " response
if [[ "$response" == "yes" || "$response" == "y" ]]; then
    echo "Continuing..."
    # Add deletion code here when ready to weaponize this script    
    for id in "${runIDs[@]}"; do
        echo "deleting" $id "..."
        gh run --repo $targetRepo delete $id
    done
elif [[ "$response" == "no" || "$response" == "n" ]]; then
    echo "Aborting...  No deletions made"
    exit 1
else
    echo "Invalid response. Please enter 'yes' or 'no'."
    exit 1
fi
