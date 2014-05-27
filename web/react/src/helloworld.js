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
