# Open policy agent hands on

## use case :

Let's say we have a blog where users can create posts and get comments on them. (Like stack overflow)


## Some of OPA CLI functions:
###  run
Can be used to open a REPL or start a server.

```sh
$ opa run --server --bundle policies

```

###  eval
The command is used in development to debug and run the policies.
Call the `delete_comment` policy with some input data
```sh
$ opa eval --data policies \
   --format pretty \
   --input inputs/delete-comment-owner.json \
   'data.office.friday.delete_comment'
```

```sh
$ opa eval --data policies \
   --format pretty \
   --input inputs/delete-comment-post-owner.json \
   'data.office.friday.delete_comment'
```

###  exec
Similar to `eval` but offers more options for evaluating policies.
```sh
$ opa exec \
    --bundle policies \
    --decision comments/rules/delete_comment \
    inputs/delete-comment-owner.json
```

###  bundle

Create a rego tarball that can be used by a running OPA instance

```sh
$ opa bundle policies
```
or target WASM, and it can be used in the browser for example.

```sh
$ opa build policies -t wasm -e comments/rules
```
###  test
Run tests on all policies :
```sh
$ opa test policies
```
###  fmt
Formats the rego files.
