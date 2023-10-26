package comments.rules

import future.keywords.contains
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

### the same function can also be written as follow
### find_user(jwt) := users[_].username == jwt.claims.username
default add_comment := false
add_comment if {
	find_user(input.jwt)
	input.action == "create"

	post := posts[_]
	post.id == input.post_id
}

# Upvote a comment
# version 1

upvote_comment if {
	user := find_user(input.jwt)

	# // array of comments
	user_comments := [comment |
		some comment in comments
		comment.email == user.email
	]

	# use a set
	# user_comments := { comment |
	# 	some comment in comments
	# 	comment.email == user.email
	# }

	# user must have more than 2 comments
	count(user_comments) > 2

	# comment should exist
	some comment in comments
	comment.id == input.comment_id
}

# # version 3 use a function
# user_comments(user) := { comment |
# 	some comment in comments
# 	comment.email == user.email
# }
# upvote_comment if {
# 	user := find_user(input.jwt)
# 	# user must have more than 2 comments
# 	count(user_comments(user)) > 2
# 	# comment should exist
# 	some comment in comments
# 	comment.id == input.comment_id
# }
