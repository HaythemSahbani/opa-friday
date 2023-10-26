package comments.rules

import future.keywords.if
import future.keywords.in

import data.dummy.comments as comments
import data.dummy.posts as posts
import data.dummy.users as users

# delete a comment
default delete_comment := false

# post owner delets a comment censorship 😈
delete_comment if {
	input.action == "delete"
	some comment in comments
	comment.id == input.comment_id
  # find a post
	some post in posts
	post.id == comment.postId

  # find a user
	some user in users
	user.username == input.jwt.claims.username
  # check if the user is the post owner
	user.id == post.userId
}

# comment owner deletes a comment
delete_comment if {
	input.action == "delete"
	some comment in comments
	comment.id == input.comment_id
  # user exists and is the creator of the commment
	user := find_user(input.jwt)
	user.email == comment.email
}

# create a helper function
find_user(jwt) := user if {
	some user in users
	user.username == jwt.claims.username
}

# the same function can also be written as follow
find_user(jwt) := users[_].username == jwt.claims.username
