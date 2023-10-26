# best practice is to separate tests from production policy packages
package comments.rules_test

import future.keywords.if

# import the package to be tested
import data.comments.rules as rules

# import all related pacakges and data
import data.dummy.comments as comments
import data.dummy.users as users
import data.dummy.posts as posts


comment_owner := { "username": "tester_1", "id": 1, "email": "tester_1@mail" }
post_owner := {"username": "tester_2", "id": 2, "email": "tester_2@mail" }

mock_users := [ comment_owner, post_owner ]

mock_comments := [{ "id": 1, "postId": 2, "email": "tester_1@mail" }]
mock_posts := [{ "id": 2, "userId": 2 }]
mock_input := {
  "action" : "delete",
  "comment_id": 1,
  "jwt": { "claims": post_owner },
}

test_delete_comment_from_its_owner_success if {
  expected := rules.delete_comment
    # object props can be mocked individually
    with input.action as "delete"
    with input.comment_id as 1
    with input.jwt as { "claims": comment_owner }
    with comments as mock_comments
    with users as mock_users

    # expects can be explicit
    expected == true
}

# if its a boolean, expects can be omitted
test_delete_comment_from_post_owner_success if {
  rules.delete_comment
    with input as mock_input
    with comments as mock_comments
    with posts as mock_posts
    with users as mock_users
}

test_delete_comment_fails if {
  # mocks can also be local
  mock_posts := [{ "id": 2, "userId": 1 }]

  not rules.delete_comment
    with input as mock_input
    with comments as mock_comments
    with posts as mock_posts
    with users as mock_users
}
