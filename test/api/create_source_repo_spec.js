var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Create a source repo')
.post(host + '/source_repos', {
  name: 'my_new_repo'
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
    name: "my_new_repo"
  })
  .after(function() {
    frisby.create('Delete repo ' + source_repo.id)
    .delete(host + "/source_repos/" + source_repo.id)
    .toss();
  })
  .toss();
})
.toss();

frisby.create('Create first duplicate source repo')
.post(host + '/source_repos', {
  name: 'a_duplicate'
}, {json: true})
.afterJSON(function(source_repo) {
  frisby.create('Cannot create duplicate source repo')
  .post(host + '/source_repos', {
    name: source_repo.name
  }, {json: true})
  .expectStatus(400)
  .after(function() {
    frisby.create('Delete repo ' + source_repo.id)
    .delete(host + "/source_repos/" + source_repo.id)
    .toss();
  })
  .toss();
})
.toss();
