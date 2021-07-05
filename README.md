## Github Action to update Ruby gems in a project

### Setup

```yaml
name: Bundle Update Action

on: workflow_dispatch

jobs:
  build:
    name: Bundle Update
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.7.2 # ruby version of a project
          bundler-cache: true
      - uses: mmnfst/bundle-update-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.PAT }} # token of your account
          BRANCH: "support/bundle-update"
          BASE_BRANCH: development
          REVIEWERS: DmitrySadovnikov,aderyabin
          ASSIGNEES: DmitrySadovnikov,aderyabin
          LABELS: Support
          GEMS: nokogiri,puma,rails # use "*" to update all gems or delete the variable
```
