var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('Create a new pipeline')
  .post(host + '/pipelines', {
        name: "My Frisby Pipeline"
    }, {json: true})
  .expectStatus(200)
  .expectHeaderContains('content-type', 'application/json')
  .expectJSON({
    name: "My Frisby Pipeline"
  })
.toss();
