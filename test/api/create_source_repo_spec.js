var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Create a source repo')
  .post(host + '/source_repos', {
        name: 'simple_pipeline'
    }, {json: true})
  .expectStatus(200)
  .expectHeaderContains('content-type', 'application/json')
  .get(host + "/source_repos", {headers: {"content-type": ""}})
  .expectStatus(200)
  .expectJSONTypes({
    source_repos: Array
  })
  .expectJSONTypes('source_repos.?', {
    name: "simple_pipeline"
  })
.toss();
