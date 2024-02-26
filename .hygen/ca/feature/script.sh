
die() {
    echo "Error: $1" >&2
    exit 1
}

create_directory() {
    mkdir -p "$1"

    # Check if the directory was created successfully
    if [ $? -ne 0 ]; then
        die "Error: Failed to create directory $1"
    fi
}

if [ $# -ne 2 ]; then
    die "Usage: script.sh {lib_directory} {feature_file_name}"
fi

LIB=$1
FEATURE_NAME=$2

if [ ! -d "$LIB" ]; then
    die "Directory $LIB does not exist." 
fi

if [ -z "$FEATURE_NAME" ]; then
    die "Feature name must not be empty."
fi

FEATURE_PATH="$LIB/features/$FEATURE_NAME"

create_directory $FEATURE_PATH
create_directory $FEATURE_PATH/data/data_sources
create_directory $FEATURE_PATH/data/dtos
create_directory $FEATURE_PATH/data/repositories
create_directory $FEATURE_PATH/domain/entities
create_directory $FEATURE_PATH/domain/use_cases
create_directory $FEATURE_PATH/domain/repositories
create_directory $FEATURE_PATH/presentation/pages
create_directory $FEATURE_PATH/presentation/shared

touch $FEATURE_PATH/data/dtos/dtos.dart