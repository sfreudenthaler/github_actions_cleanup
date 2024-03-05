#!/bin/bash

# Name: Cleanup Workflow Runs
# Author: "Steve Freudenthaler <https://github.com/sfreudenthaler>"

# This shell script is intended to quickly delete all GitHub Workflow runs 
# for a given workflow.  It's initial impetus for existance was to cleanup 
# the list of actions on [dotcms/core](https://github.com/dotCMS/core/actions/)

# Get workflow ID we want to cleanup by command arg OR if not provided, by prompt
if [ $# -eq 0 ]; then
    read -p "Which workflow (Name or ID) do you want to delete all runs? " workflowID
else
    case $1 in
        -w|--workflow) workflowID="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
    #workflowID=$1
fi

echo "You provided Workflow ID: $workflowID"

# Get the list of run id's for the provided workflow
runIDs=( $(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/dotcms/core/actions/workflows/$workflowID/runs | jq '.workflow_runs[].id') ) 

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
        gh run delete $id
    done
elif [[ "$response" == "no" || "$response" == "n" ]]; then
    echo "Aborting...  No deletions made"
    exit 1
else
    echo "Invalid response. Please enter 'yes' or 'no'."
    exit 1
fi
