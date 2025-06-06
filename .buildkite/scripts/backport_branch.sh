#!/bin/bash

source .buildkite/scripts/common.sh

set -euo pipefail

cleanup_gh() {
    pushd $WORKSPACE > /dev/null
    git config remote.origin.url "https://github.com/elastic/integrations.git"
    popd > /dev/null
}

trap cleanup_gh EXIT


DRY_RUN="$(buildkite-agent meta-data get DRY_RUN --default ${DRY_RUN:-"true"})"
BASE_COMMIT="$(buildkite-agent meta-data get BASE_COMMIT --default ${BASE_COMMIT:-""})"
PACKAGE_NAME="$(buildkite-agent meta-data get PACKAGE_NAME --default ${PACKAGE_NAME:-""})"
PACKAGE_VERSION="$(buildkite-agent meta-data get PACKAGE_VERSION --default ${PACKAGE_VERSION:-""})"
REMOVE_OTHER_PACKAGES="$(buildkite-agent meta-data get REMOVE_OTHER_PACKAGES --default ${REMOVE_OTHER_PACKAGES:-"false"})"

if [[ -z "$PACKAGE_NAME" ]] || [[ -z "$PACKAGE_VERSION" ]]; then
  buildkite-agent annotate "The variables **PACKAGE_NAME** or **PACKAGE_VERSION** aren't defined, please try again" --style "warning"
  exit 1
fi

# Report data set in the input step
PARAMETERS=(
    "**DRY_RUN**=$DRY_RUN"
    "**BASE_COMMIT**=$BASE_COMMIT"
    "**PACKAGE_NAME**=$PACKAGE_NAME"
    "**PACKAGE_VERSION**=$PACKAGE_VERSION"
    "**REMOVE_OTHER_PACKAGES**=$REMOVE_OTHER_PACKAGES"
)

# Show each parameter in a different line
echo "Parameters: ${PARAMETERS[*]}" | sed 's/ /\n- /g' | buildkite-agent annotate \
    --style "info" \
    --context "context-parameters"

FULL_ZIP_PACKAGE_NAME="${PACKAGE_NAME}-${PACKAGE_VERSION}.zip"
TRIMMED_PACKAGE_VERSION="$(echo "$PACKAGE_VERSION" | cut -d '.' -f -2)"
SOURCE_BRANCH="main"
BACKPORT_BRANCH_NAME="backport-${PACKAGE_NAME}-${TRIMMED_PACKAGE_VERSION}"
PACKAGES_FOLDER_PATH="packages"
MSG=""

isPackagePublished() {
  local packageZip=$1
  local responseCode
  responseCode=$(curl -s -o /dev/null -w "%{http_code}" "https://package-storage.elastic.co/artifacts/packages/${packageZip}")
  if [[ $responseCode == "200" ]]; then
    return 0
  else
    return 1
  fi
}

commitExists() {
  local commit_sha=$1
  local branch=$2
  git checkout $branch
  local searchResult=""
  searchResult="$(git branch --contains $commit_sha --format="%(refname:short)" | grep -E ^${branch}$)"
  git checkout $BUILDKITE_BRANCH
  if [ "${searchResult}" == "${branch}" ]; then
    echo "The commit $commit_sha exists in the branch $branch"
    return 0
  else
    echo "The commit $commit_sha doesn't exist in the branch $branch"
    return 1
  fi
}

branchExist() {
  local branch=$1
  if git ls-remote --exit-code origin "$branch" >/dev/null 2>&1; then
    echo "The backport branch $branch already exists"
    return 0
  else
    echo "The backport branch $branch does not exist"
    return 1
  fi
}

createLocalBackportBranch() {
  local branch_name=$1
  local source_commit=$2
  if git checkout -b "$branch_name" "$source_commit"; then
    echo "The branch $branch_name has been created."
  else
    buildkite-agent annotate "The backport branch **$BACKPORT_BRANCH_NAME** could not be created." --style "warning"
    exit 1
  fi
}

removeOtherPackages() {
  local sourceFolder=$1
  local currentPackage=""
  for dir in "$sourceFolder"/*; do
    if [[ -d "$dir" ]] && [[ "$(basename "$dir")" != "$PACKAGE_NAME" ]]; then
      echo "Removing directory: $dir"
      rm -rf "$dir"

      currentPackage=$(basename "${dir}")
      echo "Removing ${currentPackage} from .github/CODEOWNERS"
      sed -i "/^\/packages\/${currentPackage}\//d" .github/CODEOWNERS
      sed -i "/^\/packages\/${currentPackage} /d" .github/CODEOWNERS
    fi
  done
}

update_git_config() {
    pushd $WORKSPACE > /dev/null
    git config --global user.name "${GITHUB_USERNAME}"
    git config --global user.email "${GITHUB_EMAIL}"

    popd > /dev/null
}

updateBackportBranchContents() {
  local BUILDKITE_FOLDER_PATH=".buildkite"
  local JENKINS_FOLDER_PATH=".ci"
  local files_cached_num=""

  git checkout "$BACKPORT_BRANCH_NAME"
  echo "Copying $BUILDKITE_FOLDER_PATH from $SOURCE_BRANCH..."
  git checkout $SOURCE_BRANCH -- $BUILDKITE_FOLDER_PATH
  git add $BUILDKITE_FOLDER_PATH

  if git ls-tree -d --name-only main:.ci >/dev/null 2>&1; then
    echo "Copying $JENKINS_FOLDER_PATH from $SOURCE_BRANCH..."
    git checkout $SOURCE_BRANCH -- $JENKINS_FOLDER_PATH
    git add $JENKINS_FOLDER_PATH
  else
    if [ -d "${JENKINS_FOLDER_PATH}" ]; then
      echo "Removing $JENKINS_FOLDER_PATH from $BACKPORT_BRANCH_NAME..."
      rm -rf "$JENKINS_FOLDER_PATH"
      git add "$JENKINS_FOLDER_PATH"
    fi
  fi

  # Update scripts used by mage
  local MAGEFILE_SCRIPTS_FOLDER="dev/citools"
  local TESTSREPORTER_SCRIPTS_FOLDER="dev/testsreporter"
  local COVERAGE_SCRIPTS_FOLDER="dev/coverage"
  local CODEOWNERS_SCRIPTS_FOLDER="dev/codeowners"

  if git ls-tree -d --name-only main:${MAGEFILE_SCRIPTS_FOLDER} > /dev/null 2>&1 ; then
    echo "Copying $MAGEFILE_SCRIPTS_FOLDER from $SOURCE_BRANCH..."
    git checkout "$SOURCE_BRANCH" -- "${MAGEFILE_SCRIPTS_FOLDER}"
    git add ${MAGEFILE_SCRIPTS_FOLDER}

    echo "Copying $TESTSREPORTER_SCRIPTS_FOLDER from $SOURCE_BRANCH..."
    git checkout "$SOURCE_BRANCH" -- "${TESTSREPORTER_SCRIPTS_FOLDER}"
    git add ${TESTSREPORTER_SCRIPTS_FOLDER}

    echo "Copying $COVERAGE_SCRIPTS_FOLDER from $SOURCE_BRANCH..."
    git checkout "$SOURCE_BRANCH" -- "${COVERAGE_SCRIPTS_FOLDER}"
    git add ${COVERAGE_SCRIPTS_FOLDER}

    echo "Copying $CODEOWNERS_SCRIPTS_FOLDER from $SOURCE_BRANCH..."
    git checkout "$SOURCE_BRANCH" -- "${CODEOWNERS_SCRIPTS_FOLDER}"
    git add ${CODEOWNERS_SCRIPTS_FOLDER}

    echo "Copying magefile.go from $SOURCE_BRANCH..."
    git checkout "$SOURCE_BRANCH" -- "magefile.go"
    git add magefile.go

    # As this script runs in the context of the main branch (mainly go mod tidy), we need to copy
    # the .go-version file from the main branch to the backport branch. This avoids failures
    # installing dependencies in the backport Pull Request.
    echo "Copying .go-version from $SOURCE_BRANCH..."
    git checkout "$SOURCE_BRANCH" -- ".go-version"
    git add .go-version

    # Run go mod tidy to update just the dependencies related to magefile and dev scripts
    go mod tidy

    git add go.mod go.sum
  fi

  if [ "${REMOVE_OTHER_PACKAGES}" == "true" ]; then
    echo "Removing all packages from $PACKAGES_FOLDER_PATH folder"
    removeOtherPackages "${PACKAGES_FOLDER_PATH}"
    ls -la "${PACKAGES_FOLDER_PATH}"

    git add "${PACKAGES_FOLDER_PATH}/"
    git add .github/CODEOWNERS
  fi

  git status

  echo "Setting up git environment..."
  update_git_config

  files_cached_num=$(git diff --name-only --cached | wc -l)
  if [ "${files_cached_num}" -gt 0 ]; then
    echo "Committing changes..."
    git commit -m "Add $BUILDKITE_FOLDER_PATH and $JENKINS_FOLDER_PATH to backport branch: $BACKPORT_BRANCH_NAME from the $SOURCE_BRANCH branch"
  else
    echo "Nothing to commit, skip."
  fi

  if [ "$DRY_RUN" == "true" ];then
    echo "DRY_RUN mode, nothing will be pushed."
    # Show just the relevant files diff (go.mod, go.sum, .buildkite, dev, .go-version, .github/CODEOWNERS and package to be backported)
    git --no-pager diff $SOURCE_BRANCH...$BACKPORT_BRANCH_NAME .buildkite/ dev/ go.sum go.mod .go-version .github/CODEOWNERS "packages/${PACKAGE_NAME}"
  else
    echo "Pushing..."
    git push origin $BACKPORT_BRANCH_NAME
  fi

  cleanup_gh
}

if ! [[ $PACKAGE_VERSION =~ ^[0-9]+(\.[0-9]+){2}(\-.*)?$ ]]; then
  buildkite-agent annotate "The entered package version ${PACKAGE_VERSION} doesn't match the pattern" --style "error"
  exit 1
fi

add_bin_path

with_yq

echo "Check if the package is published"
if ! isPackagePublished "$FULL_ZIP_PACKAGE_NAME"; then
  buildkite-agent annotate "The package version: **${PACKAGE_NAME}-${PACKAGE_VERSION}** hasn't been published yet." --style "error"
  exit 1
fi

echo "Check if the base commit exists."
if [ ! -z "$BASE_COMMIT" ]; then
  if ! commitExists "$BASE_COMMIT" "$SOURCE_BRANCH"; then
    buildkite-agent annotate "The entered commit hasn't found in the **${SOURCE_BRANCH}** branch" --style "error"
    exit 1
  fi
fi

echo "Check if the backport-branch exists"
if branchExist "$BACKPORT_BRANCH_NAME"; then
  MSG="The backport branch: **$BACKPORT_BRANCH_NAME** is already created. Not updating contents of the branch."
  buildkite-agent annotate "$MSG" --style "warning"
  exit 0
fi

# backport branch does not exist, running checks and create branch
version="$(git show "${BASE_COMMIT}":"packages/${PACKAGE_NAME}/manifest.yml" | yq -r .version)"
echo "Check if version from ${BASE_COMMIT} (${version}) matches with version from input step ${PACKAGE_VERSION}"
if [[ "${version}" != "${PACKAGE_VERSION}" ]]; then
  buildkite-agent annotate "Unexpected version found in packages/${PACKAGE_NAME}/manifest.yml" --style "error"
  exit 1
fi

echo "Check that this changeset is the one creating the version $PACKAGE_NAME"
if ! git show -p ${BASE_COMMIT} packages/${PACKAGE_NAME}/manifest.yml | grep -E "^\+version: \"{0,1}${PACKAGE_VERSION}" ; then
  buildkite-agent annotate "This changeset does not creates the version ${PACKAGE_VERSION}" --style "error"
  exit 1
fi

echo "Creating the branch: $BACKPORT_BRANCH_NAME from the commit: $BASE_COMMIT"
createLocalBackportBranch "$BACKPORT_BRANCH_NAME" "$BASE_COMMIT"
MSG="The backport branch: **$BACKPORT_BRANCH_NAME** has been created."

echo "Adding CI files into the branch ${BACKPORT_BRANCH_NAME}"
updateBackportBranchContents

if [ "${DRY_RUN}" == "true" ]; then
  MSG="[DRY_RUN] ${MSG}."
fi
buildkite-agent annotate "$MSG" --style "success"
