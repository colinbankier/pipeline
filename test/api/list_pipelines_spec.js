var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Create a new pipeline')
  .post(host + '/pipelines', {
        name: "My Pipeline 1"
    }, {json: true})
  .post(host + '/pipelines', {
        name: "My Pipeline 2"
    }, {json: true})
  .afterJSON(function(pipeline) {
    frisby.create('Create nested pipeline')
    .post(host + '/pipelines/' + pipeline.id + '/tasks', {
          name: "Nested Pipeline",
          type: "pipeline"
          }, {json: true});
  })
  .post(host + '/pipelines', {
        name: "My Pipeline 3"
    }, {json: true})
  .get(host + '/pipelines', {headers: {"content-type": ""}})
  .expectJSONTypes({
      pipelines: Array
    })
.toss();
