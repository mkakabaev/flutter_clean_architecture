#!/bin/sh

# ------------------------------------------------------------------------------------------------
# This script clones the project into a new one with a different name
# ------------------------------------------------------------------------------------------------

die() {
    echo "\n$1" >&2
    exit 1
}

if [ $# -ne 2 ]; then
    die "Clone existing project to new directory\nUsage: sh fork.sh <new_project_name> <output_directory>"
fi

# ------------------------------------------------------------------------------------------------
# check project_name variable to be a valid snake_case string of length at least 2

project_name=$1

if ! [[ $project_name =~ ^[a-z][a-z0-9_]*[a-z0-9]$ ]]; then
    die "Project name should be a valid snake_case string of length at least 2"
fi
if [[ $project_name =~ "__" ]]; then
    die "Project name should not contain two consecutive underscores"
fi

output_directory="$2/$project_name"

# ------------------------------------------------------------------------------------------------
# check the destination directory to not exist (or to be empty)

if [ -d $output_directory ]; then
    if [ -n "$(ls -A $output_directory)" ]; then
        die "Output directory <$output_directory> already exists and it is not empty"
    fi
fi

mkdir -p $output_directory || die "Failed to create output directory"

# ------------------------------------------------------------------------------------------------
# copy the project files to the output directory

echo "Copying project files to $output_directory..."

script_dir=$(dirname $(readlink -f $0))
parent_dir=$(dirname $script_dir)

# Define the ignore patterns
ignore_file=$(mktemp)
cat <<EOF > $ignore_file

.DS_Store
.dart_tool/
.git
/build/
.flutter-plugins
.flutter-plugins-dependencies
*.iml
*.ipr
*.iws
.idea/
/ios/Pods/
/ios/.symlinks/
/ios/Flutter/flutter_export_environment.sh
/ios/Flutter/Generated.sh
/ios/Flutter.podspec
/ios/Runner/GeneratedPluginRegistrant.*
/android/.gradle/
/android/local.properties
/android/**/gradle-wrapper.jar
/android/**/GeneratedPluginRegistrant.java

EOF

# echo "Copying project files to $output_directory, ignore file: $ignore_file"
rsync -a --exclude-from=$ignore_file  $parent_dir/ $output_directory || die "Failed to copy project files"
rm $ignore_file

# ------------------------------------------------------------------------------------------------
# replace the project name in the copied files

echo "Renaming the project..."

oldstring="mk_clean_architecture"
newstring=$project_name
system_name=$(uname)

find $output_directory -type f -exec grep -l "$oldstring" {} \; | while read -r file
do
    # echo "Replacing $oldstring with $newstring in $file"
    if [[ "$system_name" == "Darwin" ]]; then
        sed -i '' -e "s/$oldstring/$project_name/g" "$file" || die "sed failed for $file"
    elif [[ "$system_name" == "Linux" ]]; then
        sed -i -e "s/$oldstring/$project_name/g" "$file" || die "sed failed for $file"
    else
        echo "Unsupported operating system $system_name"
    fi
done

# ------------------------------------------------------------------------------------------------
# renaming the project name in the copied files

echo "Renaming the project files..."

cd $output_directory/android/app/src/main/kotlin/com/example || die "Failed to change directory"
mv $oldstring $project_name || die "Failed to rename directory"

echo "Done"
