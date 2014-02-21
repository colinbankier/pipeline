App = Ember.Application.create();

App.TreeBranchController = Ember.ObjectController.extend({
});
App.register('controller:treeBranch', App.TreeBranchController, {singleton: false});

App.TreeBranchView = Ember.View.extend({
    tagName: 'ul',
    templateName: 'tree-branch',
    classNames: ['tree-branch']
});

App.TreeNodeController = Ember.ObjectController.extend({
    isExpanded: false,
    checked: false,
    contentDidChange: function() {
        this.set('checked', App.get('selectedNodes').contains(this.get('content')));
    }.observes('content'),
    toggle: function() {
        this.set('isExpanded', !this.get('isExpanded'));
    },
    addChild: function() {
        var text = window.prompt('Enter text for node:');
        var node = {
           text: text,
           children: []
        };
        this.get('children').pushObject(node);
    },
    checkedDidChange: function() {
        var selectedNodes = App.get('selectedNodes'),
            node = this.get('content');
        if (this.get('checked')) {
            if (!selectedNodes.contains(node)) {
                selectedNodes.pushObject(node);
            }
        } else {
            selectedNodes.removeObject(node);
        }
    }.observes('checked')
});
App.register('controller:treeNode', App.TreeNodeController, {singleton: false});

App.TreeNodeView = Ember.View.extend({
    tagName: 'li',
    templateName: 'tree-node',
    classNames: ['tree-node']
});

App.set('selectedNodes', Em.A()); //Start with an empty array

App.set('treeRoot', {
    text: 'Root',
    children: [
        {
            text: 'People',
            children: [
                {
                    text: 'Basketball players',
                    children: [
                        {
                            text: 'Lebron James',
                            children: []
                        },
                        {
                            text: 'Kobe Bryant',
                            children: []
                        }
                    ]
                },
                {
                    text: 'Astronauts',
                    children: [
                        {
                            text: 'Neil Armstrong',
                            children: []
                        },
                        {
                            text: 'Yuri Gagarin',
                            children: []
                        }
                    ]
                }
            ]
        },
        {
            text: 'Fruits',
            children: [
                {
                    text: 'Banana',
                    children: []
                },
                {
                    text: 'Pineapple',
                    children: []
                },
                {
                    text: 'Orange',
                    children: []
                }
            ]
        },
        {
            text: 'Clothes',
            children: [
                {
                    text: 'Women',
                    children: [
                        {
                            text: 'Dresses',
                            children: []
                        },
                        {
                            text: 'Tops',
                            children: []
                        }
                    ]
                },
                {
                    text: 'Men',
                    children: [
                        {
                            text: 'Jeans',
                            children: []
                        },
                        {
                            text: 'Shirts',
                            children: []
                        }
                    ]
                }
            ]
        }
    ]
});
