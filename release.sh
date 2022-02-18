#!/usr/bin/env bash

# get current branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# push any local changes
git push

# branch validation
if [ $branch = "dev" ]; then
	# check current branch is clean
	if output=$(git status --porcelain) && [ -z "$output" ]; then
		
		# get the version number
		echo "Enter the release version (eg. 1.2.0):"
		read version

		echo "Started releasing hugo-18n v$version..."

		
		# commit version updates
		git commit -a -m "🔨 Preparing release v$version"
		git push

		# switch to master branch
		git checkout master

		# pull latest from master
		git pull

		# merge in changes from dev branch
		git merge --no-ff dev -m "🔖 Release v$version"

		# create tag
		git tag "v$version"

		# push commit and tag to remote
		git push
		git push --tags

		echo "Congo v$version successfully released! 🎉"
		echo "Returning to dev branch..."

		git checkout dev

	else	
		echo "ERROR: There are unstaged changes in development!"
		echo "Clean the working directory and try again."
	fi
else 
	echo "ERROR: Releases can only be published from the dev branch!"
fi