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
    var status = "";
    for (var i = 0; i < 10; i++) {
      frisby.create("Get run result")
      .get(host + '/jobs/' + job.id)
      .expectStatus(200)
      .afterJSON(function(result) {
        status = result.status;
      })
      .inspectJSON()
      .toss();
    console.log(status);
    if (status == "success") {
      console.log("success");
      break;
    } else {
      console.log(i);
    }
    }
    expect(status).toEqual("success");
  })
  .toss();
