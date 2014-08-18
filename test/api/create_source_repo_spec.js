var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Delete source repos')
.get(host + "/source_repos", {headers: {"content-type": ""}})
.afterJSON(function(source_repo_list) {
  var source_repos = source_repo_list.source_repos;
  for(var i = 0; i < source_repos.length; i++) {
    var repo_id = source_repos[i].id;
    frisby.create('Delete repo ' + repo_id)
    .delete(host + "/source_repos/" + repo_id)
    .toss();
  }
})
.after(function() {
  frisby.create('Create a source repo')
  .post(host + '/source_repos', {
    name: 'simple_pipeline'
  }, {json: true})
  .expectStatus(200)
  .expectHeaderContains('content-type', 'application/json')
  .afterJSON(function(source_repo) {
    frisby.create('Get all source repos')
    .get(host + "/source_repos", {headers: {"content-type": ""}})
    .expectStatus(200)
    .expectJSONTypes({
      source_repos: Array
    })
    .expectJSONTypes('source_repos.?', {
      name: "simple_pipeline"
    })
    .toss();
  })
  .toss();
})
.after(function() {
  frisby.create('Create first duplicate source repo')
  .post(host + '/source_repos', {
    name: 'duplicate'
  }, {json: true})
  .afterJSON(function(source_repo) {
    frisby.create('Cannot create duplicate source repo')
    .post(host + '/source_repos', {
      name: 'duplicate'
    }, {json: true})
    .expectStatus(400)
    .toss();
  })
  .toss();
})
.toss();




