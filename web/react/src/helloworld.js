/** @jsx React.DOM */
React.renderComponent(
  <h1>Hello, world!</h1>,
   document.getElementById('example')
);

var FooComponent = React.createClass({
  render : function() {
    return <div>foo</div>;
  }
});
 
var BarComponent = React.createClass({
  render : function() {
    return <div>bar</div>;
  }
});
 
var Router = Backbone.Router.extend({
  routes : {
    "foo" : "foo",
    "bar" : "bar"
  },
  foo : function() {
    React.renderComponent(
      <FooComponent />,
      document.body
    );
  },
  bar : function() {
    React.renderComponent(
      <BarComponent />,
      document.body
    );
  }
});
 
new Router();
 
Backbone.history.start();
