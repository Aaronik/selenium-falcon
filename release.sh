#!/bin/bash

# Usage:
#
# Draft a new release based on the last semantic version (or an
# arbitrary version, if provided:
#
#     $ ./release.sh <major|minor|patch|x.y.z>
#

#####################################################

# Undoing:
#
# * Delete changes in CHANGELOG.md
# * Remove git tag with git tag -d <tag name>
# * Rollback git commit history, maybe with git reset --soft <commit hash>; git commit -am 'awesome commit message'
# * Change version number in package.json
#
# This is of course assuming you haven't pushed to the remote origin.
#

#####################################################

# Space-delimited list of built scripts to be included in the
# version commit (e.g., 'lib/vs.api.js')
# includes='lib/vs.collab.js'

# Script dependencies
DEPENDENCIES=('node' 'git' 'npm' 'semver' 'jq')

#####################################################

# This error handler will stand in for set -e.
# Report line numbers of errors if/when they happen.
function error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"

  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi

  exit "${code}"
}

# Execute the error() function above when there's an error
trap 'error ${LINENO}' ERR

#####################################################

branch=`git rev-parse --abbrev-ref HEAD`
oldVersion=`node -pe 'require("./package.json").version'`
diff="v$oldVersion...$branch"
commits=`git log $diff --no-merges --pretty=format:"  * (%an) %s"`
editor=`git config --global core.editor || echo 'vi -'`

# Check that things have changed since the last version
function check_is_ahead () {
  local commit_count=`git rev-list $diff --count`
  if [ $commit_count -lt 1 ]; then
    echo "No changes since $oldVersion!"
    reset
  fi
}

# Check whether there are any uncommited files in the current directory
function check_clean_directory () {
  git diff --exit-code > /dev/null || {
    echo 'Directory is dirty, panicking :^('
    reset
  }
}

# Check whether a command is available on the current system
function check_dependencies () {
  function bail () {
    # $1 to be missing program name
    echo "Whoops, looks like you don't have $1 installed.  Please install it and try again :)"
    exit 1
  }

  for dep in ${DEPENDENCIES[@]}; do
    which $dep >> /dev/null || bail $dep
  done

  echo "All programs installed, proceeding."
}

# Check that a git tag does not already exist
function check_unique_version () {
  if git show-ref --tags --quiet --verify -- "refs/tags/$@"; then
    echo "Tag '$1' already exists :-("
    reset
  fi
}

# Try setting things back the way they were.
function reset () {
  try_mv old-package.json package.json
  try_mv old-CHANGELOG.md CHANGELOG.md

  git reset --soft
  exit 1
}

# Try moving a file, skipping if it doesn't exist
function try_mv () {
  mv $1 $2 2>/dev/null || echo "Skipped moving '$1' → '$2'"
}

# Try removing a file, skipping if it doesn't exist
function try_rm () {
  rm $1 2>/dev/null || echo "Skipped removing '$@'"
}

function preflight_warning () {
  echo "About to create $newVersion from $branch:"
  echo "------------------------------------------------------"
  echo
  cat commit.msg
  echo
  echo "------------------------------------------------------"

  if [[ "$branch" != "master" ]]; then
    echo "WARNING: Your current branch ($branch) will be used"
    echo "         instead of master. Be VERY sure you know what"
    echo "         you're doing!"
    echo "------------------------------------------------------"
    echo
  fi

  read -r -p "Are you sure? [y/n/e]" -n 1
  confirm=$REPLY
}

# Prompt to accept or edit `commit.msg`
function prompt_commit_msg () {

  preflight_warning

  # Give the release author a chance to edit `commit.msg`
  while [ $confirm == "e" ]; do
    $editor commit.msg
    preflight_warning
  done

  # Last chance to bail
  if [[ ! $confirm =~ ^[Yy]$ ]]; then
    reset
  fi
}

# Prompt for new version (if not provided)
function prompt_new_version () {
  local proposedVersion=`semver -i patch $oldVersion`
  echo "Enter next version after $oldVersion ($proposedVersion):"
  read newVersion
  if [ -z $newVersion ]; then
    newVersion=$proposedVersion
  fi
}

# Prompt for a push to github
function prompt_push () {
  read -r -p "Push $branch to github? [y/n]" -n 1
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin $branch --tags
  fi
}

# Write a default `commit.msg`
function write_commit_msg () {
  echo "$newVersion (crafted `date +%D`)" > commit.msg
  echo >> commit.msg
  echo "Changes:" >> commit.msg
  echo >> commit.msg
  echo "$commits" >> commit.msg
}

# Write `commit.msg` to CHANGELOG.md
function write_changelog () {
  mv CHANGELOG.md old-CHANGELOG.md
  echo -n '### ' > CHANGELOG.md
  cat commit.msg >> CHANGELOG.md
  echo >> CHANGELOG.md
  echo '---' >> CHANGELOG.md
  cat old-CHANGELOG.md >> CHANGELOG.md
}

#####################################################

check_dependencies

check_clean_directory

echo 'Fetching the latest...'
git fetch

check_is_ahead

# New version may be supplied as first argument ($1). If it was *not* set,
# we'll just ask the release author to provide it.
if [ "$#" -eq 1 ]; then
  case "$1" in
    "major" | "minor" | "patch")
      newVersion=`semver -i $1 $oldVersion`
      ;;
    *)
      newVersion=$1
      ;;
  esac
else
  prompt_new_version $1
fi

newVersionTag="v$newVersion"

check_unique_version $newVersionTag

write_commit_msg
prompt_commit_msg

mv package.json old-package.json
cat old-package.json | jq ". | .version = \"$newVersion\"" > package.json

write_changelog

# Stage package, CHANGELOG, and any project-specific includes
for file in package.json CHANGELOG.md $includes; do
  echo $file && git add $file
done

# Check whether there are any unstaged changes
check_clean_directory

git commit -F commit.msg
git tag $newVersionTag

echo "Updated to $newVersion"
cat commit.msg

try_rm old-package.json
try_rm old-CHANGELOG.md
try_rm commit.msg

prompt_push

