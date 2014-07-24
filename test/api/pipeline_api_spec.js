var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Create a new pipeline')
  .post(host + '/pipelines', {
        name: "My Frisby Pipeline"
    }, {json: true})
  .expectStatus(200)
  .expectHeaderContains('content-type', 'application/json')
  .expectJSONTypes({
    id: Number,
    name: String
  })
  .expectJSON({
    name: "My Frisby Pipeline"
  })
  .afterJSON(function(pipeline) {
    frisby.create('Get a pipeline')
    .get(host + '/pipelines/' + pipeline.id)
    .expectStatus(200)
    .expectHeaderContains('content-type', 'application/json')
    .expectJSON({
      name: "My Frisby Pipeline"
    })
    .toss();
  })
.toss();

frisby.create('Create a new pipeline')
  .post(host + '/pipelines', {
        name: "My Frisby Pipeline"
    }, {json: true})
  .expectStatus(200)
  .afterJSON(function(pipeline) {
    frisby.create('Create a task')
    .post(host + '/pipelines/' + pipeline.id + '/tasks', {
      name: "My first task",
      command: "echo 1"
    }, {json: true})
    .expectStatus(200)
    .expectHeaderContains('content-type', 'application/json')
    .expectJSONTypes({
      id: Number,
      name: String
    })
    .expectJSON({
      name: "My first task"
    })
  .afterJSON(function(task) {
    frisby.create('Get a task')
    .get(host + '/pipelines/' + task.pipeline_id + '/tasks/' + task.id)
    .expectStatus(200)
    .expectHeaderContains('content-type', 'application/json')
    .expectJSON({
      name: "My first task",
      command: "echo 1"
    })
    .toss();
  })
    .toss();
  })
.toss();
