# version

Current version: 0.1.1

## Config file `.version-conf`

```bash
#!/usr/bin/env bash

current_version=0.1.1

ignore=(
    .gitignore
    docs
)
```

## Ignore

* In the `ignore` array you can add any file you don't
want to be included in the search-and-replace procedure

* By default anything in the `.gitignore` file is also being ignored by the tool

* The .git directory and the CHANGELOG.md file are also being ignored by default
