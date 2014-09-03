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
  .expectJSON({
    status: "scheduled"
  })
  .afterJSON(function(job) {
    // This doesn't do what was intended. Either polling or sleeping are awkward.
    setTimeout(function() {
      frisby.create("Get run result")
      .get(host + '/jobs/' + job.id)
      .expectStatus(200)
      .afterJSON(function(result) {
        expect(result.status).toEqual("success");
        complete = true;
      })
      .inspectJSON()
      .toss();
    }, 1000);
  })
  .toss();
