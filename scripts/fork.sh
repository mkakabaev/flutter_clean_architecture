#!/bin/sh

# 
# This script clones an existing project to a new directory
# It is used to create a new project from an existing one
# 

die() {
    echo "\n$1" >&2
    exit 1
}

if [ $# -ne 2 ]; then
    echo "\nClone existing project to new directory"
    echo "Usage: sh fork.sh <new_project_name> <output_directory>"
    exit 1
fi

project_name=$1

# check project_name variable to be a valid snake_case string of length at least 2
if ! [[ $project_name =~ ^[a-z][a-z0-9_]*[a-z0-9]$ ]]; then
    die "Project name should be a valid snake_case string of length at least 2"
fi
if [[ $project_name =~ "__" ]]; then
    die "Project name should not contain two consecutive underscores"
fi

output_directory="$2/$project_name"

# check the destination directory to not exist
if [ -d $output_directory ]; then
    if [ -n "$(ls -A $output_directory)" ]; then
        die "Output directory <$output_directory> already exists and it is not empty"
    fi
fi

mkdir -p $output_directory || die "Failed to create output directory"

# copy the project files to the output directory
script_dir=$(dirname $(readlink -f $0))
parent_dir=$(dirname $script_dir)
ignore_file=$script_dir/fork_ignore
rsync -av --exclude-from=$ignore_file  $parent_dir/ $output_directory || die "Failed to copy project files"

# replace the project name in the copied files
oldstring="mk_clean_architecture"
if [[ "$(uname)" == "Darwin" ]]; then
    find $output_directory -type f -exec grep -l $oldstring {} ';' | xargs sed -i '' -e "s/$oldstring/$project_name/g" 
elif [[ "$(uname)" == "Linux" ]]; then
    find $output_directory -type f -exec grep -l $oldstring {} ';' | xargs sed -i -e "s/$oldstring/$project_name/g" 
else
    echo "Unknown operating system"
fi

# renaming the project name in the copied files
cd $output_directory/android/app/src/main/kotlin/com/example || die "Failed to change directory"
mv $oldstring $project_name || die "Failed to rename directory"

echo "Done"