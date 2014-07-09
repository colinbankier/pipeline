var frisby = require('frisby');
var host = "http://localhost:8000";

frisby.create('Create a new pipeline')
  .post(host + '/pipelines/create', {
        name: "My Frisby Pipeline"
    }, {json: true})
  .expectStatus(200)
  .expectHeaderContains('content-type', 'application/json')
  .expectJSON('0', {
    name: "My Frisby Pipeline"
  })
.toss();
