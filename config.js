//
// renamed this config.json file to config.js to be able to introduce comments.
// required the same in nodejs.  require('config');
// only change is adding "module.exports = " to beginning of file.
//
module.exports = {
    "serverTitle": "gitlab webhook listener",
    "hostname": "localhost", // remove for os.hostname()
    "listenerPort": 9000,
    "hooks": {
	/* this "push" section handles STAGE updates to the master branch. */
        "push": {
            "secretKey": "SECRETGITLABTOKENHERE-ezproxy",
            "matches": {
                "project.default_branch": "master",
                "project.path_with_namespace": "Library/ezproxy"
            },
            "commandBatch": "/opt/ezproxy-webhook/git-pull.pl",
            "commandDir": "/opt/ezproxy"
        },
	/* this "merge_request" section handles PROD updates to the production branch. */
        "merge_request": {
            "secretKey": "SECRETGITLABTOKENHERE-ezproxy",
            "matches": {
                "project.path_with_namespace": "Library/ezproxy",
                "object_attributes.source_branch": "master",
                "object_attributes.target_branch": "production",
                "object_attributes.state": "merged",
            },
            "commandBatch": "/opt/ezproxy-webhook/git-pull.pl",
            "commandDir": "/opt/ezproxy"
        }
    }
}
