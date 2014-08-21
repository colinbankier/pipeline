var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create("Trigger a pipeline to run")
  .post(host + '/jobs', {
    source_repo: "simple_pipeline"
  }, {json: true})
  .expectStatus(200)
  .expectJSONTypes({
    id: Number
  })
  .afterJSON(function(job) {
    frisby.create("Get run result")
    .get(host + '/jobs/' + job.id)
    .expectStatus(200)
    .toss();
  })
  .toss();
