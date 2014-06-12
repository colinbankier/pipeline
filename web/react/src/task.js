/**
* @jsx React.DOM
*/

var app = app || {};

(function() {
  app.Task = React.createClass({
    render: function() {
      return (
        <div className="task">
        {this.props.index} {this.props.name}
        </div>
      );
    }
  });
})();

