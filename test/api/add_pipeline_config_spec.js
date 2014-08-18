var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Add a pipeline source dir')
  .post(host + '/source_repos', {
        path: 'simple_pipeline'
    }, {json: true})
  .expectStatus(200)
  .expectHeaderContains('content-type', 'application/json')
.toss();
