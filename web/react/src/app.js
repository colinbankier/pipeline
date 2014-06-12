/**
* @jsx React.DOM
*/

var app = app || {};

(function() {

  var PipelineView = app.PipelineView;

  React.renderComponent(
    <PipelineView url="pipeline.json"/>,
    document.getElementById('content')
  );
})();
