/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  var PipelineStatus = app.PipelineStatus;
  app.PipelineStatusView = React.createClass({
    loadFromServer: function() {
      $.ajax({
        url: this.props.url,
        dataType: 'json',
        success: function(data) {
          this.setState({data: data});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
      });
    },
    getInitialState: function() {
      return {data: {pipelineId: "", taskResults: []}};
    },
    componentWillMount: function() {
      this.loadFromServer();
    },
    render: function() {
      return (
        <PipelineStatus pipeline={this.state.data} />
      );
    }
  });
})();
